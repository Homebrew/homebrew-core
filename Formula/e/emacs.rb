class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftp.gnu.org/gnu/emacs/emacs-30.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/emacs/emacs-30.1.tar.xz"
  sha256 "6ccac1ae76e6af93c6de1df175e8eb406767c23da3dd2a16aa67e3124a6f138f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "d81d161a42f5d89476996520475596f392b3c932a66585cf89d3cc488a613d51"
    sha256 arm64_sonoma:  "b54fd2e5cd611295793cdb90d8db00b38c1e82814ccc5c3855f8fcbc492be5c9"
    sha256 arm64_ventura: "02f3e7aa4614510f085fa4da15573d90c14cbe2d28ee0f0e746bd36e762152c9"
    sha256 sonoma:        "0198d3055784fdbb38537cac2123a7436bb53fda399318c39c61d1fdcbc792b8"
    sha256 ventura:       "b49c4ce047726c7115c429ce7fecebaf31e056e94539b7b0333753f38b969778"
    sha256 arm64_linux:   "38e54b44ff7d38601ee05e206069da88b27266ad658dffb03d408f88122c45d5"
    sha256 x86_64_linux:  "2641fb80871ba22563f3fa31d2d41aedaf07a1275203214477db2cdc66bebdd0"
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

  conflicts_with cask: "emacs"
  conflicts_with cask: "emacs@nightly"

  def install
    # Mojave uses the Catalina SDK which causes issues like
    # https://github.com/Homebrew/homebrew-core/issues/46393
    # https://github.com/Homebrew/homebrew-core/pull/70421
    ENV["ac_cv_func_aligned_alloc"] = "no" if OS.mac? && MacOS.version == :mojave

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
