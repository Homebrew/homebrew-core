class Coinutils < Formula
  desc "COIN-OR utilities"
  homepage "https://github.com/coin-or/CoinUtils"
  url "https://github.com/coin-or/CoinUtils/archive/refs/tags/releases/2.11.13.tar.gz"
  sha256 "ddfea48e10209215748bc9f90a8c04abbb912b662c1aefaf280018d0a181ef79"
  license "EPL-2.0"
  compatibility_version 1
  head "https://github.com/coin-or/CoinUtils.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{^(?:releases/)?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ad87df5a27c8e124b3260c1e983fa5da10ed53d7163b57c73019cb86149ed093"
    sha256 cellar: :any,                 arm64_sequoia: "0e1eabc6d0990ce5351eee3e3449735467426875d78468024bc0f0f6f7e0da3a"
    sha256 cellar: :any,                 arm64_sonoma:  "1e1a816bf97f985c52f40c2938c4838634937f721893fb5a13d69cdac5a69769"
    sha256 cellar: :any,                 sonoma:        "b7c552ecc7d2953871f7ed4f0d7a4b38d5bd1cf7d7616597479944df06762817"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c99bd8b45aefa801e5c7f942da9e533a0eaf2fab3d071afb05bddac7f468886"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce972d87938a492c24644cecc6a5f91cacfd09acd7f2a2b873c1650f30e3b892"
  end

  depends_on "pkgconf" => :build
  depends_on "openblas"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = [
      "--datadir=#{pkgshare}",
      "--includedir=#{include}/coinutils",
      "--with-blas-incdir=#{Formula["openblas"].opt_include}",
      "--with-blas-lib=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--with-lapack-incdir=#{Formula["openblas"].opt_include}",
      "--with-lapack-lib=-L#{Formula["openblas"].opt_lib} -lopenblas",
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    # Deparallelize due to error 1: "mkdir: #{include}/coinutils/coin: File exists."
    # https://github.com/coin-or/Clp/issues/109
    ENV.deparallelize { system "make", "install" }
  end

  test do
    resource "homebrew-coin-or-tools-data-sample-p0201-mps" do
      url "https://raw.githubusercontent.com/coin-or-tools/Data-Sample/releases/1.2.11/p0201.mps"
      sha256 "8352d7f121289185f443fdc67080fa9de01e5b9bf11b0bf41087fba4277c07a4"
    end

    testpath.install resource("homebrew-coin-or-tools-data-sample-p0201-mps")

    (testpath/"test.cpp").write <<~CPP
      #include <CoinMpsIO.hpp>
      int main() {
        CoinMpsIO mpsIO;
        return mpsIO.readMps("#{testpath}/p0201.mps");
      }
    CPP

    system ENV.cxx, "test.cpp", "-I#{opt_include}/coinutils/coin",
      "-L#{opt_lib}", "-lCoinUtils"
    system "./a.out"
  end
end
