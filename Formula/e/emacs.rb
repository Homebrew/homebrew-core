class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftp.gnu.org/gnu/emacs/emacs-29.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/emacs/emacs-29.1.tar.xz"
  sha256 "d2f881a5cc231e2f5a03e86f4584b0438f83edd7598a09d24a21bd8d003e2e01"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "b962741699550a326396656d5f53a280262b24f9fdc388dcc1706e6c90e8cb4d"
    sha256 arm64_ventura:  "e91b90491464708d29959aa00caa826051d989f6699429d583988b7aca57df6f"
    sha256 arm64_monterey: "ec888c0f9c57f7a2c8bff9d33d4fea03237bd53f6b78e0c50cc86a31b5281690"
    sha256 arm64_big_sur:  "f69a760f4e1a71c234314cd99c8f0773bee2e716bca904894e2e0c6d9202ca82"
    sha256 sonoma:         "d0eaa9ab18ad860d36dd771d9ca11953000a732e4a4bdd342b87ee19bf55624d"
    sha256 ventura:        "5b644a5ecf5531d55f884f1fa5f946bc7b21480dc38e2a2cae1e1d9211899c2d"
    sha256 monterey:       "835b1767489be91a345f40c166ee40b189028a258ee44f5c695c9660123f17f2"
    sha256 big_sur:        "76c45ba72d1ca34050ab4ffd5f53cc560836a37a0f0ba96b434232368b9fa382"
    sha256 x86_64_linux:   "86ae488bbc7b6411aecb883e03774da5edc722e3fd0b07441e1b41ab3b6bd6d7"
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
  depends_on "tree-sitter"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

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
