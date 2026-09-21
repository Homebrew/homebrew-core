class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftpmirror.gnu.org/emacs/emacs-31.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/emacs/emacs-31.1.tar.xz"
  sha256 "1da5790d9580c81932b5bf700633114468da7b3412d69faa767daebf974f4586"
  license "GPL-3.0-or-later"
  revision 1
  compatibility_version 1

  bottle do
    sha256 arm64_golden_gate: "5e69cc44d20e2ec48437bec2b875e9665c86513eab0aec88ad0ab797d2e2cec5"
    sha256 arm64_tahoe:       "94788c3c3a722d705b8d9c1be997082937c7d0dec2b55c2d041e31ecbe0e2444"
    sha256 arm64_sequoia:     "c09a5cb576342b2b84c661335361746cf80e1ce79f90660a11112a726606fb10"
    sha256 arm64_sonoma:      "31cd32fba7dfd4f5053f5bbe2e376735910a474635a1fe41f400bbc5b7326d20"
    sha256 arm64_linux:       "57224b6cfe249ba96771bfcb889f84b44e51f8dc68af3c1d26eb31bc4057fbe5"
    sha256 x86_64_linux:      "b030ab6c8cc2faf4182fbfd8f5dcd154527494272003467dbc7cc8e358bd7429"
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
