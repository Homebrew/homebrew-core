class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "http://meteora.ucsd.edu/~pierce/ncview_home_page.html"
  url "ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.7.tar.gz"
  sha256 "a14c2dddac0fc78dad9e4e7e35e2119562589738f4ded55ff6e0eca04d682c82"
  revision 5

  bottle do
    sha256 "b03bd0555b5637abe754e90c0029494548b460177a0825c21c0f886bcee8c2af" => :high_sierra
    sha256 "415185d4e1dba216877d4bc55020a18f62a59008b3499ffe7fa51a334274b93c" => :sierra
    sha256 "2ab04bd88cc2d265215f48f272a50a16ef3c32cdef624e935f7ee97ec94957fb" => :el_capitan
    sha256 "d9c28e5974e1babe1b69b121827e0392fb43e44ec2caadec2db891eb5f18c78b" => :yosemite
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
