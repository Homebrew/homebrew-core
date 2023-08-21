class Clp < Formula
  desc "Linear programming solver"
  homepage "https://github.com/coin-or/Clp"
  url "https://github.com/coin-or/Clp/archive/releases/1.17.8.tar.gz"
  sha256 "f9931b5ba44f0daf445c6b48fc2c250dc12e667e59ace8ea7b025f158fe31556"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(%r{^(?:releases/)?v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "efe170c0bf8394a5db5fab7fe2eacd52471337cd7cb2d144b39c8ad621e7ff2e"
    sha256 cellar: :any,                 arm64_monterey: "9d2980cc39519cf78053c951cafee4b0fb11f900a6cef87eaff3c50f3612dcfc"
    sha256 cellar: :any,                 arm64_big_sur:  "6dc3cc5e3b85420d45d610f7743e45541b3bf62511040d5046092fd9361a73b3"
    sha256 cellar: :any,                 ventura:        "88d6a80f4da99110a34a5b37cf44324e7cad52c063db6d7fac5ae48d753b4f82"
    sha256 cellar: :any,                 monterey:       "6e458f50c974e968c541288ae791a70768caacc4f03819a0ac886edf86e6c25d"
    sha256 cellar: :any,                 big_sur:        "0562833cfb1dac1a446690e0633b64421920628f9df7dbfa0f8ce9071efabe99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e784d51dc920a31d3134473c8d92cd5ead97e34fa90d8bf1a205abe31586f4c4"
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
