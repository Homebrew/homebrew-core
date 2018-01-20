class HtopVim < Formula
  desc "Improved top (interactive process viewer) with vim-style keybindings"
  homepage "https://github.com/KoffeinFlummi/htop-vim"
  revision 1

  head do
    url "https://github.com/KoffeinFlummi/htop-vim.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-ncurses", "Build using homebrew ncurses (enables mouse scroll)"

  # Running htop can lead to system freezes on macOS 10.13
  # https://github.com/hishamhm/htop/issues/682
  depends_on MaximumMacOSRequirement => :sierra

  depends_on "ncurses" => :optional

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    htop requires root privileges to correctly display all running processes,
    so you will need to run `sudo htop`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    pipe_output("#{bin}/htop", "q", 0)
  end
end
