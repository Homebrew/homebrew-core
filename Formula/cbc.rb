class Cbc < Formula
  desc "Mixed integer linear programming solver"
  homepage "https://github.com/coin-or/Cbc"
  url "https://github.com/coin-or/Cbc/archive/releases/2.10.7.tar.gz"
  sha256 "5aa5490e2bc39c3c03f3636c9bca459cb3f8f365e0280fd0c4759ce3119e5b19"
  # update to EPL-2.0 on next release
  license "EPL-1.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "23771d5def5ca370e0824a424784be41496e7046e8e71c37b00614618370bf38"
    sha256 cellar: :any,                 arm64_big_sur:  "091af84ff691f66e18bb7283dde9bbf481ef79b5e8f052158b674dd7fb5adc9a"
    sha256 cellar: :any,                 monterey:       "7132902541accc8de0fe92b2d77e3cd1b7edd3bc650fc4e770506fe89682bebe"
    sha256 cellar: :any,                 big_sur:        "ee3b3f3af132291271b8fec9bb2280dd79500be4b5ab31645409a58e0bb68b74"
    sha256 cellar: :any,                 catalina:       "02f3f27dc38f5384b0367f3b01affcee1b2ad234f402bdb2623c3634f67b01af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d8efacff329c451b8408dfa5b78344800d76c4d6af01eac6433ebe44a8c6482"
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
