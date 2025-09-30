class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftpmirror.gnu.org/gnu/emacs/emacs-30.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/emacs/emacs-30.2.tar.xz"
  sha256 "b3f36f18a6dd2715713370166257de2fae01f9d38cfe878ced9b1e6ded5befd9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "42ddbf461362556845f06e25d6541ac6cdf06ff8c0a227cf0dd0359538d69927"
    sha256 arm64_sequoia: "6fd75aed5b6ef68991921b6e61b001272310d572e9cc3b4945aff00dfc381f59"
    sha256 arm64_sonoma:  "72c66b6f50be54465008831896d1fe2c073d8a529fd85b0d3ee434bcd683342a"
    sha256 arm64_ventura: "afebd58c6452170b9e5fe63f17c0adb4dd22c38d14617076725257154f689839"
    sha256 sonoma:        "ecb254288e6a370c502a18c3813e901862fdbd849e67aaf73378b20001bc5c05"
    sha256 ventura:       "4d1435c4b9b75e2cdfd4a55a10ead687a562ce7c755984c8ee0d04ffe2244e2b"
    sha256 arm64_linux:   "fead760aab7f1f4f4d8f092bf855366fd4ec0e40bac33270912380bede575df6"
    sha256 x86_64_linux:  "0648d7634a70f7fa72ef5de26506063a2142e613059a744ebd2b8d9140ef959c"
  end

  head do
    url "https://github.com/emacs-mirror/emacs.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "gnu-sed" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "tree-sitter"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "jpeg-turbo"
  end

  conflicts_with cask: "emacs-app"
  conflicts_with cask: "emacs-app@nightly"
  conflicts_with cask: "emacs-app@pretest"

  def install
    args = %W[
      --disable-acl
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
