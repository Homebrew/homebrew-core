class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  # TODO: Bump to use tree-sitter 0.26+ when new Emacs release supports it
  url "https://ftpmirror.gnu.org/gnu/emacs/emacs-30.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/emacs/emacs-30.2.tar.xz"
  sha256 "b3f36f18a6dd2715713370166257de2fae01f9d38cfe878ced9b1e6ded5befd9"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 arm64_tahoe:   "1e9d72a5821b09957ad3cfc98b91239bd68b905d74edc129537ae97819a49c04"
    sha256 arm64_sequoia: "d9b7aaf2b753d0e741549390f1996e3283edd8ffea377ee9450ad324b66a239e"
    sha256 arm64_sonoma:  "d9d52a9f142dbfc902e9b9edbc36d0175f999d0ccfdf8c4c55596b6f43cb2183"
    sha256 sonoma:        "c0c85e628128ff1d50d811d486a57d67aa28148730304bdbbd3a91f685935104"
    sha256 arm64_linux:   "a9091dc165ed17e69952976e3990b9027122ab1bde2d54b6aac42d1bacd3717f"
    sha256 x86_64_linux:  "558b2a64792d33ea76537a2dca64927d15b91ebd0f13e07e776b01ac8acb8495"
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
  depends_on "tree-sitter@0.25"

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
