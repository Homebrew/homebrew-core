class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "http://meteora.ucsd.edu/~pierce/ncview_home_page.html"
  url "ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.7.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/ncview--2.1.7.tar.gz"
  sha256 "a14c2dddac0fc78dad9e4e7e35e2119562589738f4ded55ff6e0eca04d682c82"
  revision 7

  bottle do
    sha256 "fd045c094963d71459d70bdc7cea679810611c4060bf9cbc0a884e71ed5232e4" => :high_sierra
    sha256 "4ecd94086339db2cf56fa2ec9cf95ab31e08a47fe9589fcb1091d49737f14516" => :sierra
    sha256 "dbc52647ec527a30388c233c1361164b427fc3eefd88c540208f536bded9e8b8" => :el_capitan
  end

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
