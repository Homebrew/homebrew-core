class Cbc < Formula
  desc "Mixed integer linear programming solver"
  homepage "https://github.com/coin-or/Cbc"
  url "https://github.com/coin-or/Cbc/archive/releases/2.10.10.tar.gz"
  sha256 "f394efecccc40a51bf79fba2c2af0bc92561f3e6b8b6e4c6e36d5e70986f734f"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "41ca69a49c76c247a65ad2d1823f1945c74ebdf561b7af9b9cf0658c39fc12e8"
    sha256 cellar: :any,                 arm64_monterey: "ad9fc6201e9b1cfff361027eeb5a45dc27fb2e2bf6094d9f66b41ec61cd8a62b"
    sha256 cellar: :any,                 arm64_big_sur:  "3b97e65bfd793f595ba6ece818b75ab073f776b8220a684c35765689fa77cf37"
    sha256 cellar: :any,                 ventura:        "1ec9f906b56d4e8d3eb4dbc04cadf06833bd04363b82c7320d854e2bea649b27"
    sha256 cellar: :any,                 monterey:       "666ed0e592258401cf184987a2faade1c20d044e9bd50139765cfbc3209a5d36"
    sha256 cellar: :any,                 big_sur:        "3e47d841e182ae9d5f7664edbfe29cb9bae86b005d9f5e4a4719f52456a0fea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0e4df0a5d5832e1ab480aa16f86339b12206866ba0785e9b4da8258192ef55c"
  end

  depends_on "pkg-config" => :build
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "osi"

  def install
    # Work around for:
    # Error 1: "mkdir: #{include}/cbc/coin: File exists."
    mkdir include/"cbc/coin"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--includedir=#{include}/cbc"
    system "make"
    system "make", "install"
    pkgshare.install "Cbc/examples"
  end

  test do
    cp_r pkgshare/"examples/.", testpath
    system ENV.cxx, "-std=c++11", "sudoku.cpp",
                    "-L#{lib}", "-lCbc",
                    "-L#{Formula["cgl"].opt_lib}", "-lCgl",
                    "-L#{Formula["clp"].opt_lib}", "-lClp", "-lOsiClp",
                    "-L#{Formula["coinutils"].opt_lib}", "-lCoinUtils",
                    "-L#{Formula["osi"].opt_lib}", "-lOsi",
                    "-I#{include}/cbc/coin",
                    "-I#{Formula["cgl"].opt_include}/cgl/coin",
                    "-I#{Formula["clp"].opt_include}/clp/coin",
                    "-I#{Formula["coinutils"].opt_include}/coinutils/coin",
                    "-I#{Formula["osi"].opt_include}/osi/coin",
                    "-o", "sudoku"
    assert_match "solution is valid", shell_output("./sudoku")
  end
end
