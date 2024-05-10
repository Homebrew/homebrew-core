class Cbc < Formula
  desc "Mixed integer linear programming solver"
  homepage "https://github.com/coin-or/Cbc"
  url "https://github.com/coin-or/Cbc/archive/refs/tags/releases/2.10.11.tar.gz"
  sha256 "1fb591dd88336fdaf096b8e42e46111e41671a5eb85d4ee36e45baff1678bd33"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "20cf15d9f4b94bda6dec714179f0bf8f4b2041befd318d47b818a2aa8f5d6544"
    sha256 cellar: :any,                 arm64_ventura:  "ab9a31d37001cccbbe991f9185c6cf579ea7c8358936838144090362f52d8f9c"
    sha256 cellar: :any,                 arm64_monterey: "6bbaea4a01bd7fde7a1eb81ac1558c5a6532b091a3934b1a6452deb7e1057251"
    sha256 cellar: :any,                 sonoma:         "92ac8263cb8afc9d316a8831a9ee0cf00c7af1443896abfd5daf2405b16728d1"
    sha256 cellar: :any,                 ventura:        "7f7abb311e436c0f62792a072a6fd5ff716fb3aad1bfedf1adada1c86faf96e5"
    sha256 cellar: :any,                 monterey:       "653963fc07b1b37d2256bc928620cf086469d1c4ad0122e1402c444f2c6f6bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15e5afed407b3fea202f1c18c8637c15b1c909121ae22b2560e6521f182621d4"
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
