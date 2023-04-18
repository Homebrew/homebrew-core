class Cbc < Formula
  desc "Mixed integer linear programming solver"
  homepage "https://github.com/coin-or/Cbc"
  url "https://github.com/coin-or/Cbc/archive/releases/2.10.9.tar.gz"
  sha256 "96d02593b01fd1460d421f002734384e4eb1e93ebe1fb3570dc2b7600f20a27e"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5cad219c2d4a6371c2d9f56fb3e225b59d4e0dd0d8ec8ff81856841bfed4018a"
    sha256 cellar: :any,                 arm64_monterey: "71ef863b217a28962072ece491da7ee1bd0b3608ad20d687f3cfd10b96b5daa4"
    sha256 cellar: :any,                 arm64_big_sur:  "8df58beceb472403f05dbaf1a821c601249955eca2f4e12d352e1dbbf1af60f4"
    sha256 cellar: :any,                 ventura:        "cb0951838409208ae6293d056a1ab80be2c36c89c76afcd1b00675d97fc0ac37"
    sha256 cellar: :any,                 monterey:       "29cb89c2e874ba69f1243ada350f6b7b248a25c5f28c14c1785e349618899681"
    sha256 cellar: :any,                 big_sur:        "e11266ac6e81462b06049703d83fdc370cd28f3d75d2f33663469f1ffa363daf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1af7e782db242fa4709e5ca8b013b247765340d8629d01e39c0ba03798d39036"
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
