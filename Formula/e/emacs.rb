class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftp.gnu.org/gnu/emacs/emacs-29.4.tar.xz"
  mirror "https://ftpmirror.gnu.org/emacs/emacs-29.4.tar.xz"
  sha256 "ba897946f94c36600a7e7bb3501d27aa4112d791bfe1445c61ed28550daca235"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "20e7866b16eaa06b26353cafaf9711eb1666617c22fc4b49ed04e3049e6d569b"
    sha256 arm64_ventura:  "8f8df523a30e54eb217adc577d6618c9c2d1da1718a15050b6921d9076fa7ca8"
    sha256 arm64_monterey: "894efa66a9caa6f2e20de12cea7d67f1709d94d702485ae7bbf472e25243cd32"
    sha256 sonoma:         "5b900dc9417f61ce1cc348df7e6d5c3fcfb3fa82254473379b3883f097633b29"
    sha256 ventura:        "88d3bf3ff1d9d7b10bf2c19bd4dda3143f9b886887f5e22a867725a5d000f276"
    sha256 monterey:       "a5be71f542b675dd3eb4d7aee4ea94d42446c984813284c04ad7f70bc7059d2d"
    sha256 x86_64_linux:   "75407dd7ca74edf2fab75546fd7a387c6477a360fb5ffb7ba63ef38b53ff0a71"
  end

  head do
    url "https://github.com/emacs-mirror/emacs.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "gnu-sed" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "tree-sitter"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
