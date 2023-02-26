class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.46.0-source/maxima-5.46.0.tar.gz"
  sha256 "7390f06b48da65c9033e8b2f629b978b90056454a54022db7de70e2225aa8b07"
  license "GPL-2.0-only"
  revision 10

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "805283024f2be2da28f828fac555d4d6f02b9bccd27cd84be8c1c4c4aa4b59fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5bde7bcb75f82f244cb4b243d264fd3796917bf97a83be02ad6947b68adfb00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2d76c2bffbf1270158e175d3713811e99f8326f7169f1cf13d091cbe376e225"
    sha256 cellar: :any_skip_relocation, ventura:        "6d7482570cbdaa892a04758fc2e17e46ee4ed6222b37a933ffddf66e79d252df"
    sha256 cellar: :any_skip_relocation, monterey:       "bd6bfb89f71bfe46f98b0f8b48102b3400e251049990790cfed636bb4fd7afcd"
    sha256 cellar: :any_skip_relocation, big_sur:        "d51bf9e64cfdf29697fd0f4e652a088cc106c381dd60673acba8a9af8074cba6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cf954ac5b454685839242d8e6638a225981c596fdac12adaf603741555116c3"
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
