class GmtAT4 < Formula
  desc "Manipulation of geographic and Cartesian data sets"
  homepage "https://gmt.soest.hawaii.edu/"
  url "ftp://ftp.soest.hawaii.edu/gmt/gmt-4.5.17-src.tar.bz2"
  mirror "https://fossies.org/linux/misc/GMT/gmt-4.5.17-src.tar.bz2"
  mirror "https://mirrors.ustc.edu.cn/gmt/gmt-4.5.17-src.tar.bz2"
  sha256 "d69c4e2075f16fb7c153ba77429a7b60e45c44583ebefd7aae63ae05439d1d41"
  revision 1

  bottle do
    sha256 "77a64e9260c43b2b58951437d8ad0da89b441470cb843478b6a37710f3779f76" => :high_sierra
    sha256 "8ce903e9308096b89fff71891f1ddd01137de752e0499529e7b4d37cf20370ec" => :sierra
    sha256 "325cb0512dfa12a4cab3f499968abecfc5c48d42c579b7588f74e4201699866e" => :el_capitan
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
