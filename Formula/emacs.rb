class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftp.gnu.org/gnu/emacs/emacs-28.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/emacs/emacs-28.1.tar.xz"
  sha256 "28b1b3d099037a088f0a4ca251d7e7262eab5ea1677aabffa6c4426961ad75e1"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "63e819e025b63ae5ddd5f0f34d6ca965e8678c981f32dc83824eff59b35c2814"
    sha256 arm64_big_sur:  "11efe35336b565b8f9c1584b02d12a3de1a17b0a12764af6273425dd34898c08"
    sha256 monterey:       "c258d8cb6b85d377381e8adda32f00bcd3d7b3db37ee4fd05cce09815d0c36f7"
    sha256 big_sur:        "f246447a7575f2ff5a41332f23b50d72a1d26e43cdccad30f22bb5af1a4cc0f8"
    sha256 catalina:       "e29f1627f58d9a02cfdcc56c426dcdaa257bc6e74482e4d250abe034553bf0ca"
    sha256 x86_64_linux:   "cfb6ef8f158d521f115e66707091a36e84b63f165930979eb8948b796116aa7b"
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
