class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "https://cirrus.ucsd.edu/ncview/"
  url "https://cirrus.ucsd.edu/~pierce/ncview/ncview-2.1.11.tar.gz"
  sha256 "597cfddf9c2d7993e9b0b86bca1b73839567ee9116ee33f6d750a449b5033d91"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?ncview[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e3346928e2612dabba4b6798e8f9cb497ff302f1972344cd5271dbb2034ad2ae"
    sha256 cellar: :any,                 arm64_sequoia: "2834b30675b2ef5ac05d70cf900f8dee5543198f5bdd95e67af41a732222f9c4"
    sha256 cellar: :any,                 arm64_sonoma:  "65dcdc11101cafd4f43490814d21345cc5f4ffb9c57a8f64fb396b2731fda2ed"
    sha256 cellar: :any,                 arm64_ventura: "2bc952df1f41c6f9050a745254138365ae9496d82b1be390712d69820dca9409"
    sha256 cellar: :any,                 sonoma:        "2936bd01d289bc341a2a52e604692c7baa1611f8a2f7aa33d2a2c8e0fef22081"
    sha256 cellar: :any,                 ventura:       "51021664ece85a65f8941d091657cd9c10f7a6d5875cd2306cf8cd3d50437ef9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29d0391497116f259d6adbe90d555e92bc49a78fc040e0ba3636354f0cf8284d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed6715afe50ab90f472bcdd31e4b51f047b0705796cc1e103162f74d113a4f44"
  end

  depends_on "libice"
  depends_on "libpng"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxt"
  depends_on "netcdf"
  depends_on "udunits"

  on_linux do
    depends_on "libxext"
  end

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
                 shell_output("DISPLAY= #{bin}/ncview -c 2>&1", 1)
  end
end
