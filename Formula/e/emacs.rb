class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftp.gnu.org/gnu/emacs/emacs-29.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/emacs/emacs-29.3.tar.xz"
  sha256 "c34c05d3ace666ed9c7f7a0faf070fea3217ff1910d004499bd5453233d742a0"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "9df5c8fc4bf416fea8965b256ec49ec12d4d3693a369fde29fa5a9f4b304d0af"
    sha256 arm64_ventura:  "1092605e902ad642d7e3346a9fe6605899f10f408a2d2c3b50d7d8408aa53e3c"
    sha256 arm64_monterey: "01b043bc1eee38a606999e148a74bd29d9bf0763baf3cb6f8f1477fd7324a77a"
    sha256 sonoma:         "f955eb0981734a52a9ef168d6d2a3946ed406f2eec177caba985743427335f5d"
    sha256 ventura:        "41fc10312eb60e46f41e948617d41f16b32f4365b24fe9c0b8eef03827060fbc"
    sha256 monterey:       "90826084a843438ab493370b0fb2ebd82d4431ab13d962b68febecc4955adeaf"
    sha256 x86_64_linux:   "c09767110a53ddb890f83b6169f683df28b2c02f4a5ed4085c957575be7a258a"
  end

  head do
    url "https://github.com/emacs-mirror/emacs.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "gnu-sed" => :build
    depends_on "texinfo" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "tree-sitter"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
