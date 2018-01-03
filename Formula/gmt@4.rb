class GmtAT4 < Formula
  desc "Manipulation of geographic and Cartesian data sets"
  homepage "https://gmt.soest.hawaii.edu/"
  url "ftp://ftp.soest.hawaii.edu/gmt/gmt-4.5.17-src.tar.bz2"
  mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/gmt-4.5.17-src.tar.bz2"
  sha256 "d69c4e2075f16fb7c153ba77429a7b60e45c44583ebefd7aae63ae05439d1d41"

  bottle do
    sha256 "3e108c443ab2108305dee67e56863f0e78e2b91a574b5047505f4eae7ddc9c9a" => :high_sierra
    sha256 "26c43c1bff1ed3932f15c0c2c8d69f6277e8a1bd824c438f19b612cb5b03ca16" => :sierra
    sha256 "e6dbfe4deb702ea7791ff014bf95f008575d5e0bcc4b80097d89a36236abd622" => :el_capitan
  end

  keg_only :versioned_formula

  depends_on "gdal"
  depends_on "netcdf"

  resource "gshhg" do
    url "ftp://ftp.soest.hawaii.edu/gmt/gshhg-gmt-2.3.7.tar.gz"
    mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/gshhg-gmt-2.3.7.tar.gz"
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
