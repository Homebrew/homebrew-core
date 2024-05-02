class Clp < Formula
  desc "Linear programming solver"
  homepage "https://github.com/coin-or/Clp"
  url "https://github.com/coin-or/Clp/archive/refs/tags/releases/1.17.9.tar.gz"
  sha256 "b02109be54e2c9c6babc9480c242b2c3c7499368cfca8c0430f74782a694a49f"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(%r{^(?:releases/)?v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7f9c9a92ee99cd58465990fe1a5b0eea86b793b1b85443b686484276f0ce27d5"
    sha256 cellar: :any,                 arm64_ventura:  "17bad573877ae8f874338ee776d53bde7a322cb0170e67641162bab6c2cf3b4b"
    sha256 cellar: :any,                 arm64_monterey: "266553c24bb15cca1b4dcfbd44fef937db5823d18b12cbfc02cfaf102adb4b43"
    sha256 cellar: :any,                 sonoma:         "7a80f23d0e92466a1ae9e31885737c2ee10b45095fa4059e9da6ea19066aeaed"
    sha256 cellar: :any,                 ventura:        "3124a065da0e993785eb90ae0b48e1866347267618fe2b45820564a521090acb"
    sha256 cellar: :any,                 monterey:       "3bb2642ad847e14d942e8b3274a4217b6010d664adfaf5625233103e9465f3ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a61110512ca9feed14da907c7d8ed159dcde989728433e5ee34b5debce1ac3e"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "coinutils"
  depends_on "openblas"
  depends_on "osi"

  resource "coin-or-tools-data-sample-p0033-mps" do
    url "https://raw.githubusercontent.com/coin-or-tools/Data-Sample/releases/1.2.12/p0033.mps"
    sha256 "8ccff819023237c79ef32e238a5da9348725ce9a4425d48888baf3a0b3b42628"
  end

  def install
    # Work around https://github.com/coin-or/Clp/issues/109:
    # Error 1: "mkdir: #{include}/clp/coin: File exists."
    mkdir include/"clp/coin"

    args = [
      "--datadir=#{pkgshare}",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--includedir=#{include}/clp",
      "--prefix=#{prefix}",
      "--with-blas-incdir=#{Formula["openblas"].opt_include}",
      "--with-blas-lib=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--with-lapack-incdir=#{Formula["openblas"].opt_include}",
      "--with-lapack-lib=-L#{Formula["openblas"].opt_lib} -lopenblas",
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    resource("coin-or-tools-data-sample-p0033-mps").stage testpath
    system bin/"clp", "-import", testpath/"p0033.mps", "-primals"
    (testpath/"test.cpp").write <<~EOS
      #include <ClpSimplex.hpp>
      int main() {
        ClpSimplex model;
        int status = model.readMps("#{testpath}/p0033.mps", true);
        if (status != 0) { return status; }
        status = model.primal();
        return status;
      }
    EOS
    pkg_config_flags = `pkg-config --cflags --libs clp`.chomp.split
    system ENV.cxx, "test.cpp", *pkg_config_flags
    system "./a.out"
  end
end
