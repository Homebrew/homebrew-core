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
    rebuild 1
    sha256 arm64_tahoe:   "b543c7f67a1b82570fad2420b29915a1a52ce9ec8fcc48671bdbce77fe9d21c3"
    sha256 arm64_sequoia: "04cac5742a25b61d4a8bcff66708109f455ec4c758520f542faf41ee55f7cdf1"
    sha256 arm64_sonoma:  "655ed2f5dc5bd33d1855a302dfee5156608576a5b26b56913256bf9f4cfaa680"
    sha256 sonoma:        "19cd1d2285e96a773535d7f4f31e39e8405fcc0531d54c143a64bb9e686a7d6f"
    sha256 arm64_linux:   "56d1d96343d318623ed86f2f785b4bd9a33b36fe1b19cc9f60aa981d86994da5"
    sha256 x86_64_linux:  "32507fbd3da18c3e6285b2747f2f514273de1a47e2e5a9ae3f5d08521b40a931"
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

  on_linux do
    depends_on "jpeg-turbo"
    depends_on "zlib-ng-compat"
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
