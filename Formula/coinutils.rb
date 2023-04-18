class Coinutils < Formula
  desc "COIN-OR utilities"
  homepage "https://github.com/coin-or/CoinUtils"
  url "https://github.com/coin-or/CoinUtils/archive/releases/2.11.8.tar.gz"
  sha256 "202e347d1c1d2ccf5355e3c2874a4dc16500226c180b00d6677f464d80be337e"
  license "EPL-2.0"
  head "https://github.com/coin-or/CoinUtils.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{^(?:releases/)?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fa292a656cbf3cae85c2d212b27ae33f0f5b12cfa30e2f77ac57049a100b91e6"
    sha256 cellar: :any,                 arm64_monterey: "0443c24aeb4925f014b58d540d45beea6c3ecf09a6bdba4f3b172422d786bb98"
    sha256 cellar: :any,                 arm64_big_sur:  "ebb61ba658209aaa30e5752030952e2ee41e4ce7d836bdb76e1d8b3ef855ad0c"
    sha256 cellar: :any,                 ventura:        "2b90c3c0523fc2ecd3195485f092625bad579d4e689ba661b67a190e13243419"
    sha256 cellar: :any,                 monterey:       "c76b88eb171244ef9c0bc04585da9ef5f07ce3fdc18292d419051d2ce2abb6e2"
    sha256 cellar: :any,                 big_sur:        "1fbac90ddbada711cc4833fcf00a2010f8914cdce4c30a1ad0fe5ebf1357e3c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc0bf098f772f94bb5b7b9e290d981bab049c9e432503b467d22c8a6d1dda3a0"
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
