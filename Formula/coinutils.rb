class Coinutils < Formula
  desc "COIN-OR utilities"
  homepage "https://github.com/coin-or/CoinUtils"
  url "https://github.com/coin-or/CoinUtils/archive/releases/2.11.4.tar.gz"
  sha256 "d4effff4452e73356eed9f889efd9c44fe9cd68bd37b608a5ebb2c58bd45ef81"
  license "EPL-1.0"
  revision 1
  head "https://github.com/coin-or/CoinUtils.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{^(?:releases/)?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "77667560f272c61296ff337793c19cd68a0803a2ba595afc617aa4ccd18819b7"
    sha256 cellar: :any,                 monterey:      "fdac3efa544c60718403da22fef94cca2a6a0a32b63abb31f48f0f8ace3eb023"
    sha256 cellar: :any,                 big_sur:       "0fa99baebe3b99ff42b2d344806077f16afa0f8d9db076892030a0551fdac231"
    sha256 cellar: :any,                 catalina:      "ec360d8c70a2f54dc6ab4cbabedf3e7f801bc1ae85e630ef9884d0a79ad706f0"
    sha256 cellar: :any,                 mojave:        "eb85ec2e02aed09292625122dc05fbcf64b85d7f82cc6d001975eed43cfc1de1"
    sha256 cellar: :any,                 high_sierra:   "f7bfde6c8c42b6f7d3925de0577d10bcef5b171b3337ea4c70b08a8ec20c026a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55979b76df6afed32c1173ead21666d0f3e98aaf4962eb93093478f4c2e70793"
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
