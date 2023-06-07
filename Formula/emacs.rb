class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftp.gnu.org/gnu/emacs/emacs-28.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/emacs/emacs-28.2.tar.xz"
  sha256 "ee21182233ef3232dc97b486af2d86e14042dbb65bbc535df562c3a858232488"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "f4a933ab0cb1c3f28dedc0704425fd34a48710845958287614589c9a73f4649e"
    sha256 arm64_monterey: "ba71e6b793a5292ca964d3541cfb4222b968715110df1b5566f0f907b6ad673d"
    sha256 arm64_big_sur:  "c11c264e7a5a947c06ae724bcd7ea7314c440f1014fdee1fb69adf23df76a17d"
    sha256 ventura:        "db8c4b591ce83a564907c7208d045563da103c64f20450bf234e7355fcc27c9c"
    sha256 monterey:       "4ae23c3a1fa87f997f08d77b874b3ca2995655173125ac0c9b62776a76899f35"
    sha256 big_sur:        "41e45b591cec75cee7f9c08355356d35ca92e06eae2ece10b08abc1088798d18"
    sha256 x86_64_linux:   "8612bf10b8605184e317c8ce31a0ea7a3c4d10785b5fe074a189b3b11146deb4"
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
    depends_on "jpeg-turbo"
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
