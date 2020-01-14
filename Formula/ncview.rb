class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "https://web.archive.org/web/20190806213507/meteora.ucsd.edu/~pierce/ncview_home_page.html"
  url "ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.8.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/ncview--2.1.8.tar.gz"
  sha256 "e8badc507b9b774801288d1c2d59eb79ab31b004df4858d0674ed0d87dfc91be"
  revision 1

  bottle do
    sha256 "e4346135421cd4cb576d861c9681c76286843eb58c9c523c1260efb48258d3c9" => :catalina
    sha256 "eaac4b5cfe872a16a7c6aedc07485103f15ed00844e82d01abb0c73b9ca3e4eb" => :mojave
    sha256 "6e11005ff9f9ab9c1634b6476e8f56b289b2a6d3e14c53ad98e0e699dc144bf8" => :high_sierra
  end

  depends_on "libpng"
  depends_on "netcdf"
  depends_on "udunits"
  depends_on :x11

  def install
    # Bypass compiler check (which fails due to netcdf's nc-config being
    # confused by our clang shim)
    inreplace "configure",
      "if test x$CC_TEST_SAME != x$NETCDF_CC_TEST_SAME; then",
      "if false; then"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    man1.install "data/ncview.1"
  end

  test do
    assert_match "Ncview #{version}",
                 shell_output("#{bin}/ncview -c 2>&1", 1)
  end
end
