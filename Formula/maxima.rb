class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.46.0-source/maxima-5.46.0.tar.gz"
  sha256 "7390f06b48da65c9033e8b2f629b978b90056454a54022db7de70e2225aa8b07"
  license "GPL-2.0-only"
  revision 5

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab666fe2f72acf79b6c17df2a741c4d45ca9e5e3047d74627fb287b7308bce10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9c4dedb0129387aa107588f9cff5419249774fbeaaf2860ce5d25a8d4565df8"
    sha256 cellar: :any_skip_relocation, monterey:       "56e7dbb2b5928893e2cf37d93ffe0bfd8581405da9993222d22921f406554ffd"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc584ffe3cd9ec799ceba2904f80611dfd01807502e40818b7b0107863bbfe6a"
    sha256 cellar: :any_skip_relocation, catalina:       "f24ac077158d061c058530f4267dd8bc013a1874a97eee7f3c3edf79104736cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c5b4252b1660638798624dd8cd621327bed69f7f63940a9c3cc9232a1517411"
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
