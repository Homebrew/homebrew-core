class Coinutils < Formula
  desc "COIN-OR utilities"
  homepage "https://github.com/coin-or/CoinUtils"
  url "https://github.com/coin-or/CoinUtils/archive/releases/2.11.6.tar.gz"
  sha256 "6ea31d5214f7eb27fa3ffb2bdad7ec96499dd2aaaeb4a7d0abd90ef852fc79ca"
  license "EPL-2.0"
  head "https://github.com/coin-or/CoinUtils.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{^(?:releases/)?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4f0abffd41926e53bfa6800c137fe67258e719b44a81dec61936af141f903c15"
    sha256 cellar: :any,                 arm64_monterey: "6944f390ccf74b973faa8dcbc13ff97f6cb8cbeffc3b1c9c415ae24bdeb8b6b5"
    sha256 cellar: :any,                 arm64_big_sur:  "dd06dd58ad6291f329683d8f96a389c216a41331280a24a0efa61eea6c91f7b8"
    sha256 cellar: :any,                 ventura:        "d83cb501b2a741332eae9ff42c0fe3d48625d1480c1d59b688ecbd9cae20418a"
    sha256 cellar: :any,                 monterey:       "a03146ddb16bf6c58ccdbc1da737bd8e797ee1fdf5886dba42239f1c0102cfff"
    sha256 cellar: :any,                 big_sur:        "d848773a9c4464d789d67fb24130d6fc2b810345f893fef3e59afa486b329559"
    sha256 cellar: :any,                 catalina:       "194e7c44c08a3078b190887d13327d847062bb38fe89f65d3066b605b533bf1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81564519b5159afdda85183c450f6429e340955dff15fab2dbc7f92354ccf5ef"
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
