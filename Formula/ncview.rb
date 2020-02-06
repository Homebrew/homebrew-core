class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "https://web.archive.org/web/20190806213507/meteora.ucsd.edu/~pierce/ncview_home_page.html"
  url "ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.8.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/ncview--2.1.8.tar.gz"
  sha256 "e8badc507b9b774801288d1c2d59eb79ab31b004df4858d0674ed0d87dfc91be"
  revision 2

  bottle do
    sha256 "22f52c20555686c0bcd09fa3a05d4242206b833077fc733aa07150b693512a9b" => :catalina
    sha256 "263cf170dcb3cedf1d992f0c70e231e2b1a8b0326e26b34b6f75330ffcf2dc3c" => :mojave
    sha256 "0c5f57cbcfff8df4006d76b7b6e7d223fce19f2c87ef2fbaa7eae62caf425aef" => :high_sierra
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
