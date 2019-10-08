class Coinutils < Formula
  desc "COIN-OR utilities"
  homepage "https://github.com/coin-or/CoinUtils"
  url "https://github.com/coin-or/CoinUtils/archive/releases/2.11.3.tar.gz"
  sha256 "7c4753816e765974941db75ec89f8855e56b86959f3a5f068fdf95b0003be61c"

  bottle do
    cellar :any
    sha256 "f2218aa3a46657a4a41bf25bf05a4100faf99c3d96efb1662d7e30bdf2b1acc6" => :catalina
    sha256 "9558f2e26a1585b9a8c6bbd1942e204bc2e08806eb9771cb96e6de987c8fcec8" => :mojave
    sha256 "ac4abeaa19b49c6d566087a19e0f45a2c2c7be703e6013ca6d6a1a0f76505e07" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openblas"

  resource "coin-or-tools-data-sample-p0201-mps" do
    url "https://raw.githubusercontent.com/coin-or-tools/Data-Sample/releases/1.2.11/p0201.mps"
    sha256 "8352d7f121289185f443fdc67080fa9de01e5b9bf11b0bf41087fba4277c07a4"
  end

  def install
    args = [
      "--datadir=#{pkgshare}",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--includedir=#{include}/coinutils",
      "--prefix=#{prefix}",
      "--with-blas-incdir=#{Formula["openblas"].opt_include}",
      "--with-blas-lib=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--with-lapack-incdir=#{Formula["openblas"].opt_include}",
      "--with-lapack-lib=-L#{Formula["openblas"].opt_lib} -lopenblas",
    ]
    system "./configure", *args
    system "make"

    # Deparallelize due to error 1: "mkdir: #{include}/coinutils/coin: File exists."
    # https://github.com/coin-or/Clp/issues/109
    ENV.deparallelize
    system "make", "install"
  end

  test do
    resource("coin-or-tools-data-sample-p0201-mps").stage testpath
    (testpath/"test.cpp").write <<~EOS
      #include <CoinMpsIO.hpp>
      int main() {
        CoinMpsIO mpsIO;
        return mpsIO.readMps("#{testpath}/p0201.mps");
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{opt_include}/coinutils/coin",
      "-L#{opt_lib}", "-lCoinUtils"
    system "./a.out"
  end
end
