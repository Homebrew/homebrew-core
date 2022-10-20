class Cbc < Formula
  desc "Mixed integer linear programming solver"
  homepage "https://github.com/coin-or/Cbc"
  url "https://github.com/coin-or/Cbc/archive/releases/2.10.8.tar.gz"
  sha256 "8525abb541ee1b8e6ff03b00411b66e98bbc58f95be1aefd49d2bca571be2eaf"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9c6816ac51c4f6dfce9211077647576e41c87484d80fe80f37b10b010357292c"
    sha256 cellar: :any,                 arm64_big_sur:  "f6d4d0d73a51b53cb17920352f78c1d7aba923d53ecc4bd3a7a4fa9968e7bdb5"
    sha256 cellar: :any,                 monterey:       "58cd161d62e3c14010428dbe330a90858424f6fbb44b7da7337c2bbd21475dcb"
    sha256 cellar: :any,                 big_sur:        "9dfd9b522f7488c4f8e09277d38f8a73fce9ee7e3febf2a7cec27005130e8659"
    sha256 cellar: :any,                 catalina:       "255d298551bab042bd860bdd1a6fa005fb17ed61bf80bc4288a7862387dba4fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72a1c63a9b265b697e1be4ae6abbb90d002467fa4699ca0123cbb4cb4bba3da9"
  end

  depends_on "pkg-config" => :build
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "osi"

  def install
    # Work around - same as clp formula
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
