class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "https://web.archive.org/web/20190806213507/meteora.ucsd.edu/~pierce/ncview_home_page.html"
  url "ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.8.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/ncview--2.1.8.tar.gz"
  sha256 "e8badc507b9b774801288d1c2d59eb79ab31b004df4858d0674ed0d87dfc91be"

  bottle do
    sha256 "6728af3ab82b4598d60c52a5bd3f0f1a94077876e4936b45c430743657d248aa" => :catalina
    sha256 "6fdf161cfd6faac506618bb965093c051611eacfe53e1af4fe40cf526328d08c" => :mojave
    sha256 "b9f8db64be40f663d9f3c4edef70bf6c8843347f4095ac06e5ead7126426020b" => :high_sierra
    sha256 "fbfa69cf9cde49fecf167b327a54e89f3d8be022957af39bda161ded33149201" => :sierra
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
