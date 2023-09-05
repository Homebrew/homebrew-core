class Coinutils < Formula
  desc "COIN-OR utilities"
  homepage "https://github.com/coin-or/CoinUtils"
  url "https://github.com/coin-or/CoinUtils/archive/releases/2.11.9.tar.gz"
  sha256 "15d572ace4cd3b7c8ce117081b65a2bd5b5a4ebaba54fadc99c7a244160f88b8"
  license "EPL-2.0"
  head "https://github.com/coin-or/CoinUtils.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{^(?:releases/)?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e128f68e7b7b57a947deeeafda81ed30c0fb83e49a4c8986508dc8b042140bcd"
    sha256 cellar: :any,                 arm64_monterey: "83d0958d9de79ffdc75670607d4bc051fe9f390d5aedfb72e0974732005806b5"
    sha256 cellar: :any,                 arm64_big_sur:  "94c51f335a7d7f7eb233bd2bcc7dd9e1523753bda3046a01a38553553ce60d26"
    sha256 cellar: :any,                 ventura:        "07179b2940c27689e601d7f700d8a8e08a0d05cea46ec549ea1f2c693032390e"
    sha256 cellar: :any,                 monterey:       "503c15755800c6317a1f807c8a1cf04ac4d43ed817240f0e1f68559d697cabc3"
    sha256 cellar: :any,                 big_sur:        "748e0e405663940dec0aea8841d004c22ef0431432067d0e494d8339069022b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a905269ccb4b8b016e7356b06076ec2327d418b1d28190668f2fdff4d3ec05f6"
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
