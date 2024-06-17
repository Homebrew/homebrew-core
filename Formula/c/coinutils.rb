class Coinutils < Formula
  desc "COIN-OR utilities"
  homepage "https://github.com/coin-or/CoinUtils"
  url "https://github.com/coin-or/CoinUtils/archive/refs/tags/releases/2.11.11.tar.gz"
  sha256 "27da344479f38c82112d738501643dcb229e4ee96a5f87d4f406456bdc1b2cb4"
  license "EPL-2.0"
  head "https://github.com/coin-or/CoinUtils.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{^(?:releases/)?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c6f4e5097a9ce01d7b84040a54feefd4d500a762c4e9b9e873f32fe6b35ef90f"
    sha256 cellar: :any,                 arm64_ventura:  "51e76a5938f3e44d9c9aef20e35e811e2f1313f54e3e8e4bdf2b7a3367b236ea"
    sha256 cellar: :any,                 arm64_monterey: "40e36c57acec28ff44f4669e4478bae2b96b2b8d8312837dfdc468eecd1a7895"
    sha256 cellar: :any,                 sonoma:         "2d7b6ccf3c0435b1e9ddc52023f420bca498a7a961067f6c45d1cb67536512fd"
    sha256 cellar: :any,                 ventura:        "1bab0113b0831b8c22954341608f78e41c2340c5c199490c2ada32f0427080f5"
    sha256 cellar: :any,                 monterey:       "d77ec299c8427040cc64489be26358220fc2107219aee34a42511ff40b09a88c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4498d03f65d0c91c28f2a7717a23eca8ee019101f47e847d41bdf5a6ccbf2dfd"
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
    ENV.deparallelize { system "make", "install" }
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
