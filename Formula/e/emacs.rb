class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftpmirror.gnu.org/gnu/emacs/emacs-31.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/emacs/emacs-31.1.tar.xz"
  sha256 "1da5790d9580c81932b5bf700633114468da7b3412d69faa767daebf974f4586"
  license "GPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "d0c7c334b8daad65a3b6b18a4b493c896ba38e3dbd47c0e87920aac7aaee367a"
    sha256 arm64_sequoia: "453b9b0f9035e7448eacef5da8da7659f053cac6323a6cddb8cd19c36ac69047"
    sha256 arm64_sonoma:  "1594755ea9f3c58262cc94f1001342958b54bf046eaf4ce4c7fff3139f956a53"
    sha256 sonoma:        "de654478bf6a2df5bd1f959683079e3a8b20753b5d8349b8c789ad2059b61248"
    sha256 arm64_linux:   "5e645484523df3a7efc80e8912c62e609462507d2c49b0d8ab18a2352a2ea2cb"
    sha256 x86_64_linux:  "5b5dcc1b47301905e2da31d3f81ce1fc7e60217671306913197b4132d298b581"
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
      ENV.prepend_path "PATH", formula_opt_libexec("gnu-sed")/"gnubin"
      system "./autogen.sh"
    end

    File.write "lisp/site-load.el", <<~LISP
      (setq exec-path (delete nil
        (mapcar
          (lambda (elt)
            (unless (string-match-p "Homebrew/shims" elt) elt))
          exec-path)))
    LISP

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  service do
    run [opt_bin/"emacs", "--fg-daemon"]
    keep_alive true
  end

  test do
    assert_equal "4", shell_output("#{bin}/emacs --batch --eval=\"(print (+ 2 2))\"").strip
  end
end
