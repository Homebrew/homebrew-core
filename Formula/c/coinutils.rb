class Coinutils < Formula
  desc "COIN-OR utilities"
  homepage "https://github.com/coin-or/CoinUtils"
  url "https://github.com/coin-or/CoinUtils/archive/refs/tags/releases/2.11.12.tar.gz"
  sha256 "eef1785d78639b228ae2de26b334129fe6a7d399c4ac6f8fc5bb9054ba00de64"
  license "EPL-2.0"
  revision 1
  head "https://github.com/coin-or/CoinUtils.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{^(?:releases/)?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e7d81a41d6e627c20590a2274ddff867ef0cb374ada54382d4f42ac9c1aaf60a"
    sha256 cellar: :any,                 arm64_sequoia: "a71671fe93e3f64ddc1945014df439ae62a4ce1f34b06297493ab098d325ab80"
    sha256 cellar: :any,                 arm64_sonoma:  "8fa54d2944aab6397aee50ebd474ff6f6528bfe6db74a168c3582c21af877f38"
    sha256 cellar: :any,                 sonoma:        "e5294294a0e779ca3d0144f2868ff1a07fe442ccd409c33e1ef8472490b42866"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbaef1db6779987275e5c6033bce45ce08e578868b86fb0a6c2a9c79a06670ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59a8562a21f95781aab014c8b5dd4001a0443e4b9dd2c8ae22d28879d6e9d75d"
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
