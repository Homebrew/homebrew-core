class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftp.gnu.org/gnu/emacs/emacs-27.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/emacs/emacs-27.2.tar.xz"
  sha256 "b4a7cc4e78e63f378624e0919215b910af5bb2a0afc819fad298272e9f40c1b9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "89d8ecc54baa2d25ffed5cb54ed2f4a088c8b7907446bbf320bf2334adacef72"
    sha256 arm64_big_sur:  "f08cd18fa19f49b85606cc4a871272ef4ff9da656c4c952bd91ac03a70dbb0e3"
    sha256 monterey:       "6b5cf4c587d0b36c4ab36596006721399e073b766ee5a1ca2e798d7a1fdce051"
    sha256 big_sur:        "5d3af874e5acd76ddc881406ed1e7db8b84f96e01812961f3bee347d278a28ac"
    sha256 catalina:       "53b0d78af688a20e12e89751217c9da81cc9621222f289836d44011762355879"
    sha256 mojave:         "4b3cd25d5f6977ecad49d9b5ebd2dec3c7e41efa8f4f22d2805917e0024cf3af"
    sha256 x86_64_linux:   "3a22201d4ecf2d32fc7a0d402e14e20ce043bc25b6ac53ec15d48f585e51c9e2"
  end

  head do
    url "https://github.com/emacs-mirror/emacs.git"

    depends_on "autoconf" => :build
    depends_on "gnu-sed" => :build
    depends_on "texinfo" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "jansson"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "jpeg"
  end

  def install
    # Mojave uses the Catalina SDK which causes issues like
    # https://github.com/Homebrew/homebrew-core/issues/46393
    # https://github.com/Homebrew/homebrew-core/pull/70421
    ENV["ac_cv_func_aligned_alloc"] = "no" if MacOS.version == :mojave

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
