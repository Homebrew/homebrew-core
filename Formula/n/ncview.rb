class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "https://cirrus.ucsd.edu/ncview/"
  url "https://cirrus.ucsd.edu/~pierce/ncview/ncview-2.1.11.tar.gz"
  sha256 "597cfddf9c2d7993e9b0b86bca1b73839567ee9116ee33f6d750a449b5033d91"
  license "GPL-3.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?ncview[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5e7a66ee669661ddcc3212e291e1b9f315dc81e97a7457471c16fa806bb7f604"
    sha256 cellar: :any,                 arm64_sonoma:  "6ff3a39169afd61af20dac04a213f0ef832e6a11f928d358fb2145a5ef249d6d"
    sha256 cellar: :any,                 arm64_ventura: "f3909f25f887347c09702cb0b64464a7a2e7ee6432bb04e932954fe6daca6576"
    sha256 cellar: :any,                 sonoma:        "94e98efb569e6580c73cc3f4c5f4e28bb06440c447c6ff292b5d11cc02aca350"
    sha256 cellar: :any,                 ventura:       "b41fef5fc2a91cd5dfb10b4a934aa473cda99c532ec99fd15849afedf665fb4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4a7443caf71f6f422b38f1aa1b332793871815a6f75c0669b9ca5bc19bafdf8"
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
