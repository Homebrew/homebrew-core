class Cgoban < Formula
  desc "Go-related services"
  homepage "https://cgoban1.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cgoban1/cgoban1/1.9.14/cgoban-1.9.14.tar.gz"
  sha256 "3b8a6fc0e989bf977fcd9a65a367aa18e34c6e25800e78dd8f0063fa549c9b62"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "a224cfdd74e8cc232edf360168bc0a7061abf5ce58b8c0723e5df156cb00604d" => :big_sur
    sha256 "4cbe85bec961d2960ef76b905fac08ef7c01bb01ad5b380934dbc365f3a17768" => :arm64_big_sur
    sha256 "e61d461ae44716ab681151657ff73af5b438f306419142a247543b14de951ab4" => :catalina
    sha256 "65a58482e8da31098a71ed49467b069bff5a6172df8304bb1bccd579301abca2" => :mojave
    sha256 "4fc05de2c69a98f7c1dbd55303a508ac50e6bb3a3b6297ebd43ec4bf5a79c14d" => :high_sierra
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
