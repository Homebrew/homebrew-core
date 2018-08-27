class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "http://meteora.ucsd.edu/~pierce/ncview_home_page.html"
  url "ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.7.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/ncview--2.1.7.tar.gz"
  sha256 "a14c2dddac0fc78dad9e4e7e35e2119562589738f4ded55ff6e0eca04d682c82"
  revision 7

  bottle do
    sha256 "93de594b654c796c01c878a4ed3c6121670803d1253c0b9ffb931b7926483e48" => :high_sierra
    sha256 "66e3fc9112e66697150bdd2236287c713353e9e95a9ad95839332eef82c8a88e" => :sierra
    sha256 "c3415470f5b7b41bc7b5ee57515a7bd35b762115c89eb1d5e2c76ea9d375c531" => :el_capitan
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
