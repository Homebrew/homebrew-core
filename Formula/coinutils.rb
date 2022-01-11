class Coinutils < Formula
  desc "COIN-OR utilities"
  homepage "https://github.com/coin-or/CoinUtils"
  url "https://github.com/coin-or/CoinUtils/archive/releases/2.11.6.tar.gz"
  sha256 "6ea31d5214f7eb27fa3ffb2bdad7ec96499dd2aaaeb4a7d0abd90ef852fc79ca"
  license "EPL-1.0"
  head "https://github.com/coin-or/CoinUtils.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{^(?:releases/)?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "172fe85fa422e5ea9416830f80d5c68a907048267942cd94f097ac3364d83c4c"
    sha256 cellar: :any,                 arm64_big_sur:  "07c9fffbca1d97fb058df4a5729ca10b0fd9484e9b3813a9f3dc3635a0bf28d1"
    sha256 cellar: :any,                 monterey:       "2d664b0d063589d45027253a17dc155c9a451175c8cdd745a6937355351379b2"
    sha256 cellar: :any,                 big_sur:        "e3d61a9e45ae5cd5bc6c44b29075b1722e4b6058000da1e73232e2972d6446d4"
    sha256 cellar: :any,                 catalina:       "931ab0523ebfa67ee38bda69013a70592e83ab3a846484ff40bfff5cba316034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20fff183db5e3846544f3325dd64a2e210eab5492a9c45277b8dc841bb86e85b"
  end

  depends_on "pkg-config" => :build
  depends_on "openblas"

  resource "homebrew-coin-or-tools-data-sample-p0201-mps" do
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
    resource("homebrew-coin-or-tools-data-sample-p0201-mps").stage testpath
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
