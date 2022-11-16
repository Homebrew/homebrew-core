class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftp.gnu.org/gnu/emacs/emacs-28.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/emacs/emacs-28.2.tar.xz"
  sha256 "ee21182233ef3232dc97b486af2d86e14042dbb65bbc535df562c3a858232488"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "d020b6a9144f8fa619c067eeb0885969d5f1a171f238950ead32c8a037681c84"
    sha256 arm64_monterey: "109fb5a7ab9ad048b04169c10bc7af54814ea366a1b7d8d45a54692aed585a41"
    sha256 arm64_big_sur:  "824782de415411e7bb107143d1505fc9f844ecc15ffa2157a0987e0e282a396f"
    sha256 ventura:        "9609f3ab6395623867ab8856b42127d37d837074060060f6bed2fc2c3a349d21"
    sha256 monterey:       "d47f7fabda9e2e2e3679608253debb6865061a28f45045c8319b65d569268096"
    sha256 big_sur:        "2163de8aa7c2150522e7d8b025ad4ea68ad628118ae4f9602f616c6866aaec95"
    sha256 catalina:       "387278e4f542a29ca68598ead7a9671074fd75744db3a643db1af2702aa0f835"
    sha256 x86_64_linux:   "ad7f9af688ff25c9a7ec44cda8a287529c27e9e32ed3a1e8cd0c33d1f4a430ca"
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
