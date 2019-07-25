class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "http://meteora.ucsd.edu/~pierce/ncview_home_page.html"
  url "ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.7.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/ncview--2.1.7.tar.gz"
  sha256 "a14c2dddac0fc78dad9e4e7e35e2119562589738f4ded55ff6e0eca04d682c82"
  revision 10

  bottle do
    sha256 "49b0560fad1302ab92d5e259c62d893deb80ef5703e970e2e4ff982d7e4f6b8b" => :mojave
    sha256 "ce2795bcc8575c47ddfce0a16a8c9aab5f30ed925c6a2440dbe5eee136e018b8" => :high_sierra
    sha256 "fd1c64e7a79c0793bd89f0d2a5dedc9f08972cfcb26929abc49dbddc4ac6be0b" => :sierra
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
