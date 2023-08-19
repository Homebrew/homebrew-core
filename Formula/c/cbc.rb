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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "32da450c124aa43693350de653d23fa411fabaed1ba97f8e94933573eb0e1357"
    sha256 cellar: :any,                 arm64_monterey: "fd6a0b813968f05f2bad57997854b015544b05e1f85b311491e8a91ee740f52f"
    sha256 cellar: :any,                 arm64_big_sur:  "196878c4018b81771965a8bda4708df33265570d1eaa8af8556188da729e8ecc"
    sha256 cellar: :any,                 ventura:        "8aed7852512faccee24efcb137c5ca34dbb34a0623286ab197a85d5d45528686"
    sha256 cellar: :any,                 monterey:       "f5e472945f58484d6ac18920aca10ed79e9dd64e41b98cfb5dec00e0e9def371"
    sha256 cellar: :any,                 big_sur:        "a206dcdd7b939067d87e21689f2c55f97259ae2cff3941813de0ef7fa555d715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbfab36d64d93b418cf658d0f06a73eaff5a582124846b5740e9756a07f5a0d5"
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
                          "--includedir=#{include}/cbc",
                          "--enable-cbc-parallel"
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
