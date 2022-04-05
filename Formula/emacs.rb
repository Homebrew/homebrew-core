class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftp.gnu.org/gnu/emacs/emacs-28.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/emacs/emacs-28.1.tar.xz"
  sha256 "28b1b3d099037a088f0a4ca251d7e7262eab5ea1677aabffa6c4426961ad75e1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "5d5b7979695c455cd0a9155c839ad8781633946801f49e380eb08eff61360a9d"
    sha256 arm64_big_sur:  "7d92995b203d41d78f20bf1684f84dd07309f65dbfb1cdb4924be51210f61b63"
    sha256 monterey:       "88cc27885119741d9721968636687d2ca9be3d7ebd8c2e5b2cf83c3bf8d5e878"
    sha256 big_sur:        "fb1317cd13820dd4ebee6b7ba7196bb3486bc1636f4dde79e73b3533bd94d7d8"
    sha256 catalina:       "7b4630d3158d31b3db01c16c45e9a62a4b6a219dcde1d7fe952718a16f7538a6"
    sha256 x86_64_linux:   "0cd470905fed77977b8df909c0f1d4fc80b230207857bd79cb940d156d09eabb"
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
