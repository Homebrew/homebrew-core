class GmtAT4 < Formula
  desc "Manipulation of geographic and Cartesian data sets"
  homepage "https://gmt.soest.hawaii.edu/"
  url "ftp://ftp.soest.hawaii.edu/gmt/gmt-4.5.16-src.tar.bz2"
  mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/gmt-4.5.16-src.tar.bz2"
  sha256 "4ef6a55605821c3569279a7088586dfdcf1e779dd01b4c957db096cc60fe959d"
  revision 1

  bottle do
    sha256 "ba9c831819f97513ada5081af6ceea626db593b8292e64d57d333885246ec130" => :high_sierra
    sha256 "6044401d42210d958557b9194c4ae0a779f83c733158c946c1bf396e8471d3ed" => :sierra
    sha256 "8b93d95db2ee9f4bc577493284faa322839533323b5a96c3211296261482efbe" => :el_capitan
    sha256 "9f30a138411c966953810ffb1412d8d19ea1de9c89a5f36020bf614ccaffc02c" => :yosemite
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
