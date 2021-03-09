class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.44.0-source/maxima-5.44.0.tar.gz"
  sha256 "d93f5e48c4daf8f085d609cb3c7b0bdf342c667fd04cf750c846426874c9d2ec"
  license "GPL-2.0"
  revision 3

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1b3cd50dfe24a1cb2767a6c95515d615b8efce9b8cf6de8c4fe96f44ccbc73b6"
    sha256 cellar: :any_skip_relocation, big_sur:       "b0002ba34b984e449257a23e83f8ea495664a589cf5e9eabf8f5ea2b90269344"
    sha256 cellar: :any_skip_relocation, catalina:      "0a1bea5dfe4ceeab29522bb9ef23c22e48627a50effbea345e4f8a2fbcf4423a"
    sha256 cellar: :any_skip_relocation, mojave:        "6f2a11fbcf5fa8822e846964ac67bdb2584c26c940434ab44615a04f9e4dde11"
  end

  depends_on "gawk" => :build
  depends_on "gnu-sed" => :build
  depends_on "perl" => :build
  depends_on "texinfo" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "rlwrap"
  depends_on "sbcl"

  def install
    ENV["LANG"] = "C" # per build instructions
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--prefix=#{prefix}",
           "--enable-gettext",
           "--enable-sbcl",
           "--with-emacs-prefix=#{share}/emacs/site-lisp/#{name}",
           "--with-sbcl=#{Formula["sbcl"].opt_bin}/sbcl"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/maxima", "--batch-string=run_testsuite(); quit();"
  end
end
