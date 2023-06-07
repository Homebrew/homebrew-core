class Cgoban < Formula
  desc "Go-related services"
  homepage "https://cgoban1.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cgoban1/cgoban1/1.9.14/cgoban-1.9.14.tar.gz"
  sha256 "3b8a6fc0e989bf977fcd9a65a367aa18e34c6e25800e78dd8f0063fa549c9b62"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6cfdc10b3ee48e9bdf8d2017b7ef9d046c902e6dde142212c7dc901b4b8ecbff"
    sha256 cellar: :any,                 arm64_monterey: "a4c0a38fed9e2acdd4f7c33cf88f690a55c13fc102490da8220c649c967d2250"
    sha256 cellar: :any,                 arm64_big_sur:  "4cbe85bec961d2960ef76b905fac08ef7c01bb01ad5b380934dbc365f3a17768"
    sha256 cellar: :any,                 ventura:        "b0695f58c0e104e1bac7d68944abdf2d2a0432b47726a94474fe7bd16399b22b"
    sha256 cellar: :any,                 monterey:       "38db7de0defae5cc7cd3af37eb7ae2c9a3230d972d1136e5ad0768b845762a32"
    sha256 cellar: :any,                 big_sur:        "a224cfdd74e8cc232edf360168bc0a7061abf5ce58b8c0723e5df156cb00604d"
    sha256 cellar: :any,                 catalina:       "e61d461ae44716ab681151657ff73af5b438f306419142a247543b14de951ab4"
    sha256 cellar: :any,                 mojave:         "65a58482e8da31098a71ed49467b069bff5a6172df8304bb1bccd579301abca2"
    sha256 cellar: :any,                 high_sierra:    "4fc05de2c69a98f7c1dbd55303a508ac50e6bb3a3b6297ebd43ec4bf5a79c14d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19e955a8b73f238d18ccfe0737230ad8db200a27e7f00ae1f27ade5d5f8568b2"
  end

  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-x",
                          "--x-includes=#{Formula["libx11"].opt_include}",
                          "--x-libraries=#{Formula["libx11"].opt_lib}"
    system "make", "install"
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}/cgoban --version")
  end
end
