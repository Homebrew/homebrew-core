class Cbc < Formula
  desc "Mixed integer linear programming solver"
  homepage "https://github.com/coin-or/Cbc"
  url "https://github.com/coin-or/Cbc/archive/releases/2.10.5.tar.gz"
  sha256 "cc44c1950ff4615e7791d7e03ea34318ca001d3cac6dc3f7f5ee392459ce6719"
  # update to EPL-2.0 on next release
  license "EPL-1.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "447d1c2350025c4a124bbcd4158f6caae27cd8371cc51e349b9b4ab0660539f9"
    sha256 cellar: :any,                 monterey:      "6887340f5a6c8c2244bb572a765ed694b35f56f3b28f77672e466150895a0fb7"
    sha256 cellar: :any,                 big_sur:       "d3953110eb8c6662186ed8ca4068bf5497fa042d5237aee931a0f42501979c7f"
    sha256 cellar: :any,                 catalina:      "56fee588e216483d5b63e6e6f61dc824325da64f61fcaa7af3c3f6692c0a004d"
    sha256 cellar: :any,                 mojave:        "d415cd6ac5c7afdda6e54d74e1acf76282ad81170333690bcd2ae3c08babdff5"
    sha256 cellar: :any,                 high_sierra:   "e1c7da5d2d650279cbc41a2dd6fe36d39f6298de743b59a27fbde6645f8f748b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e53459f6a7ba1830099bee6f01f5fafe488164ff6454edbf0eff70f4c68613d1"
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
