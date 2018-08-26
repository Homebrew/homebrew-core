class GmtAT4 < Formula
  desc "Manipulation of geographic and Cartesian data sets"
  homepage "https://gmt.soest.hawaii.edu/"
  url "ftp://ftp.soest.hawaii.edu/gmt/gmt-4.5.18-src.tar.bz2"
  mirror "https://fossies.org/linux/misc/GMT/gmt-4.5.18-src.tar.bz2"
  mirror "https://mirrors.ustc.edu.cn/gmt/gmt-4.5.18-src.tar.bz2"
  sha256 "27c30b516c317fed8e44efa84a0262f866521d80cfe76a61bf12952efb522b63"

  bottle do
    sha256 "fec9e33bd015ea59d3459f592d6f60ec77a20af6cf05a800c37cb6964157790d" => :mojave
    sha256 "248b76386487b09b1a61088683386be7123a66f3e4212746358a557955ccfc41" => :high_sierra
    sha256 "8f07cef6234e6c0a5f775abdb6c346c053225fa85f1d73376bd6c67d121f5a2e" => :sierra
    sha256 "45e186cb424e153e769cacf4e6b78a66951e2c6c53574c47a3a9852f5b541a33" => :el_capitan
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
