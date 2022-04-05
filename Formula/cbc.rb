class Cbc < Formula
  desc "Mixed integer linear programming solver"
  homepage "https://github.com/coin-or/Cbc"
  url "https://github.com/coin-or/Cbc/archive/releases/2.10.7.tar.gz"
  sha256 "5aa5490e2bc39c3c03f3636c9bca459cb3f8f365e0280fd0c4759ce3119e5b19"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ba53ab073c9dfe54e7e350153cd6362cd9bdb4b859e64e16a34d4f3000d0b676"
    sha256 cellar: :any,                 arm64_big_sur:  "cb9cda04a4b2ede7adf9e75bf7c96ed85d1dfadd67c7a80cefd27b443c05b26a"
    sha256 cellar: :any,                 monterey:       "2989abdac90634bd356939a82acb2b8efe0411b67f5b6c84bba1abe0de576359"
    sha256 cellar: :any,                 big_sur:        "6aa7f580766fddec320fbdb3f573aef2a4f9e2ab3e218392b389f7ac5beaab10"
    sha256 cellar: :any,                 catalina:       "b6c6354b27a584a4fdb61e13ae3406a9b80478d023be1f5084a4b9da13d69b61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f37aae46e6800124424873c8cbcaf9dde7fbdbe606fa7261f26de04139b4771"
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
