class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "http://meteora.ucsd.edu/~pierce/ncview_home_page.html"
  url "ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.7.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/ncview--2.1.7.tar.gz"
  sha256 "a14c2dddac0fc78dad9e4e7e35e2119562589738f4ded55ff6e0eca04d682c82"
  revision 8

  bottle do
    sha256 "bee5774fef793dec088f6ad641aa04ee535ccc74a6ed329bb696ce0df575e1a1" => :mojave
    sha256 "e1547c62f4f463f23cc2f0625e49c8d81ae99f453c67ee014fb67b9879d96719" => :high_sierra
    sha256 "4b8210f42b906b910226bdfe6b6eaa2be73a8c81b8b01443599d89efdb5628de" => :sierra
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
