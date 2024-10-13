class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "https://cirrus.ucsd.edu/ncview/"
  url "https://cirrus.ucsd.edu/~pierce/ncview/ncview-2.1.10.tar.gz"
  sha256 "08d9cefb58a25b41316296074dccfe24147c3b7ea1af071cbfe785eff9f0dc65"
  license "GPL-3.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?ncview[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9c32e0c8d61208d3573870a33349e73dd07aed488fa950efc9209aad3499d464"
    sha256 cellar: :any,                 arm64_sonoma:   "5b5169eca0a60caf8ecf81577a4defc72f8d18f97836fbdd69cddf1ec9d4215e"
    sha256 cellar: :any,                 arm64_ventura:  "96ab79560d36c63a53c61ed9974738627eb217cbe69bea25b625ac2f4a8deba2"
    sha256 cellar: :any,                 arm64_monterey: "5e634d2eb02f6a4e7fb1e35ef14920816262def3495d76697edeb76af115c2fb"
    sha256 cellar: :any,                 sonoma:         "e23c7440e27e4395c5c7dc5df2d1f39b18be9961b9bbdceec5b4de3fbff97238"
    sha256 cellar: :any,                 ventura:        "ba35d1867da98ec3b6046414749366c07b5cd71efa1f9d2205e36699beeddd54"
    sha256 cellar: :any,                 monterey:       "5e9dc69c8c96e2e9e5184f78041a6bf9d58c4b6ec10e213b937476b5bb049c99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1962ae80242970e6d4a782be711680746eda4dfcd160d2e9990005856bc8be80"
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
