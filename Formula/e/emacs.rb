class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftp.gnu.org/gnu/emacs/emacs-29.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/emacs/emacs-29.3.tar.xz"
  sha256 "c34c05d3ace666ed9c7f7a0faf070fea3217ff1910d004499bd5453233d742a0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "b12c5e622a5deee34290b765420b402e9954b4ecf2ff4a769000c06a052d877c"
    sha256 arm64_ventura:  "a0ed7c0789772bf97ec57bdfa3c700889380a4534209a35830d8ed590c870588"
    sha256 arm64_monterey: "0fe859e3f01afc8106824d46fdc6d600e41e195c2288cb33581e29317c941d04"
    sha256 sonoma:         "641e9baccb0a0c7888f4dd2f9858f86f9cc157215305721e19f724bd7ac91aa6"
    sha256 ventura:        "3c0d3d684f029b2f0f73e79858b2ae02f6f3627238d8575c10eb044561e720a3"
    sha256 monterey:       "1d2fd8db496416b05319b39336aa5085f0dcce10ba6cbc8338dd79bff1e4a936"
    sha256 x86_64_linux:   "46b50c4b1164c0f527134920d174bdc690df601ce41daa32f40e78a9ac3d738b"
  end

  head do
    url "https://github.com/emacs-mirror/emacs.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "gnu-sed" => :build
    depends_on "texinfo" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "tree-sitter"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "jpeg-turbo"
  end

  def install
    # Mojave uses the Catalina SDK which causes issues like
    # https://github.com/Homebrew/homebrew-core/issues/46393
    # https://github.com/Homebrew/homebrew-core/pull/70421
    ENV["ac_cv_func_aligned_alloc"] = "no" if OS.mac? && MacOS.version == :mojave

    args = %W[
      --disable-silent-rules
      --enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp
      --infodir=#{info}/emacs
      --prefix=#{prefix}
      --with-gnutls
      --without-x
      --with-xml2
      --without-dbus
      --with-modules
      --without-ns
      --without-imagemagick
      --without-selinux
      --with-tree-sitter
    ]

    if build.head?
      ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
      system "./autogen.sh"
    end

    File.write "lisp/site-load.el", <<~EOS
      (setq exec-path (delete nil
        (mapcar
          (lambda (elt)
            (unless (string-match-p "Homebrew/shims" elt) elt))
          exec-path)))
    EOS

    system "./configure", *args
    system "make"
    system "make", "install"

    # Follow MacPorts and don't install ctags from Emacs. This allows Vim
    # and Emacs and ctags to play together without violence.
    (bin/"ctags").unlink
    (man1/"ctags.1.gz").unlink
  end

  service do
    run [opt_bin/"emacs", "--fg-daemon"]
    keep_alive true
  end

  test do
    assert_equal "4", shell_output("#{bin}/emacs --batch --eval=\"(print (+ 2 2))\"").strip
  end
end
