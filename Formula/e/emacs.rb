class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftp.gnu.org/gnu/emacs/emacs-29.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/emacs/emacs-29.3.tar.xz"
  sha256 "c34c05d3ace666ed9c7f7a0faf070fea3217ff1910d004499bd5453233d742a0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "53ec8e721b0a8c4c8736f61914a434b0c507fd58f2e266d830401db506f96195"
    sha256 arm64_ventura:  "9ac86c78a160bb6133eab4edbd4f3bfcf9c9b560b64a4fb5dac5a5d2188cc8b5"
    sha256 arm64_monterey: "53641263144a1207bed238e9c9aafe96a7c62b0201edbd80369f3860dfdd2266"
    sha256 sonoma:         "0aca3f2c6f4fd52fb25d045ca67cdc61c2c2ffaa1697c408f86295928a16d97f"
    sha256 ventura:        "baf07e2ef477b45c69e77808b48e3b7eb7faebff0793c7de60a931cc730dd3e2"
    sha256 monterey:       "a8f0deb61b4cef1180672641b49114f3d19e99a827faf497cb1f5e4ebb47a327"
    sha256 x86_64_linux:   "f979fd64cd148b53fb735d37cdca3e5fc8daa186bebc74b260a5b158f82e1ae7"
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
