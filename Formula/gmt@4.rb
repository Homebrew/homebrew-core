class GmtAT4 < Formula
  desc "Manipulation of geographic and Cartesian data sets"
  homepage "https://gmt.soest.hawaii.edu/"
  url "ftp://ftp.soest.hawaii.edu/gmt/gmt-4.5.18-src.tar.bz2"
  mirror "https://fossies.org/linux/misc/GMT/gmt-4.5.18-src.tar.bz2"
  mirror "https://mirrors.ustc.edu.cn/gmt/gmt-4.5.18-src.tar.bz2"
  sha256 "27c30b516c317fed8e44efa84a0262f866521d80cfe76a61bf12952efb522b63"
  revision 5

  bottle do
    sha256 "af612fc0897e66f8b019c2c627c258660fd6a1c93405f0530551c0bafd53369c" => :catalina
    sha256 "e3350e06c424fe32e0b20532c0589affb36406930747f6b8c41d7c510eb235bd" => :mojave
    sha256 "5741caf61b491bfe27f4b3aff36550085653a0bfd4cdc7d58e1df5f5258d2a2c" => :high_sierra
    sha256 "2a633e4769f899759837fa328f31fea2ac181599d6b0b1f54e4402fd9d44f423" => :sierra
  end

  keg_only :versioned_formula

  depends_on "gdal"
  depends_on "netcdf"

  resource "gshhg" do
    url "ftp://ftp.soest.hawaii.edu/gmt/gshhg-gmt-2.3.7.tar.gz"
    mirror "https://fossies.org/linux/misc/GMT/gshhg-gmt-2.3.7.tar.gz"
    mirror "https://mirrors.ustc.edu.cn/gmt/gshhg-gmt-2.3.7.tar.gz"
    sha256 "9bb1a956fca0718c083bef842e625797535a00ce81f175df08b042c2a92cfe7f"
  end

  def install
    ENV.deparallelize # Parallel builds don't work due to missing makefile dependencies
    system "./configure", "--prefix=#{prefix}",
                          "--datadir=#{share}/gmt4",
                          "--enable-gdal=#{Formula["gdal"].opt_prefix}",
                          "--enable-netcdf=#{Formula["netcdf"].opt_prefix}",
                          "--enable-shared",
                          "--enable-triangle",
                          "--disable-xgrid",
                          "--disable-mex"
    system "make"
    system "make", "install-gmt", "install-data", "install-suppl", "install-man"
    (share/"gmt4").install resource("gshhg")
  end

  test do
    system "#{bin}/gmt pscoast -R-90/-70/0/20 -JM6i -P -Ba5 -Gchocolate > test.ps"
    assert_predicate testpath/"test.ps", :exist?
  end
end
