" Begin .vimrc

" Pathogen Calls
call pathogen#infect()
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

" Pathogen Stuff
set runtimepath^=~/.vim/bundle/ctrlp.vim

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Set backup directory
set backupdir=~/.vim/tmp/

" Line numbering
set number

" Reduce tab length from 8 to 4
set tabstop=4
set smarttab
set softtabstop=4
set shiftwidth=4
set expandtab

" Set Wordwrap for long lines (superceded by ToggleWrap() below)
" set lbr
" set wrap
" set wrapmargin=8	" wrap margin begins 8 chars from right

syntax on

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" Color Schemes
if has('gui_running')
    set background=light
    set guifont=Monaco:h24
else
    set background=dark
endif
colorscheme solarized

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                        Expansions and Key Bindings
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Map JK to <ESC> for easier return to normal mode
map! jk <ESC>

" Expand 'dts' to a Date Stamp
:iab dts <C-R>=strftime("%c")<CR>

" Don't use Ex mode, use Q for formatting (commented out: can't
" remember what it does!)
" map Q gq

" Clear search highlight by hitting Enter.
" The <tt>/<BS></tt> is a trick to clear the command line.
" The final <CR> restores the standard behaviour so
" pressing Enter moves to the next line.
:nnoremap <CR> :nohlsearch<CR>/<BS><CR>

" Markdown and Smartypants integration
nmap <Leader>sp :%!Smartypants.pl <cr>
nmap <Leader>md :%!Markdown.pl --html4tags <cr>

" Toggle word wrap and easy line movement with \w
noremap <silent> <Leader>w :call ToggleWrap()<CR>
function ToggleWrap()
    if &wrap
        echo "Wrap OFF"
        setlocal nowrap
        set virtualedit=all
        silent! nunmap <buffer> <Up>
        silent! nunmap <buffer> <Down>
        silent! nunmap <buffer> <Home>
        silent! nunmap <buffer> <End>
        silent! iunmap <buffer> <Up>
        silent! iunmap <buffer> <Down>
        silent! iunmap <buffer> <Home>
        silent! iunmap <buffer> <End>
    else
        echo "Wrap ON"
        setlocal wrap linebreak nolist
        set virtualedit=
        setlocal display+=lastline
        noremap  <buffer> <silent> <Up>   gk
        noremap  <buffer> <silent> <Down> gj
        noremap  <buffer> <silent> <Home> g<Home>
        noremap  <buffer> <silent> <End>  g<End>
        inoremap <buffer> <silent> <Up>   <C-o>gk
        inoremap <buffer> <silent> <Down> <C-o>gj
        inoremap <buffer> <silent> <Home> <C-o>g<Home>
        inoremap <buffer> <silent> <End>  <C-o>g<End>
        noremap  <buffer> <silent> k gk
        noremap  <buffer> <silent> j gj
        noremap  <buffer> <silent> 0 g0
        noremap  <buffer> <silent> $ g$
    endif
endfunction

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              Vim Menu Options                       "
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" From Vim help file: Use F4 to invoke the menus, and arrow keys to navigate
" Enter selects, and Esc quits.
:source $VIMRUNTIME/menu.vim
:set wildmenu
:set cpo-=<
:set wcm=<C-Z>
:map <F4> :emenu <C-Z>

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              Autocmd Secion                         "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  set nowrap
  call ToggleWrap()

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set some QuickCursor helpers:
  " autocmd BufNewFile,BufRead *.txt setlocal wrap linebreak nolist textwidth=0 wrapmargin=0 
  " Set some text-editing related to quickcursor
  autocmd BufWinEnter /private/var/folders/vk/*/T/* 
              \ set textwidth=0 wrapmargin=0 ft=markdown bufhidden=delete |

  " Auto set nvAlt Notes to MarkDown format
  autocmd BufWinEnter ~/Dropbox/Notes/* set ft=markdown |

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" End .vimrc

