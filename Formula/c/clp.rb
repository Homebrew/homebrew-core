class Clp < Formula
  desc "Linear programming solver"
  homepage "https://github.com/coin-or/Clp"
  url "https://github.com/coin-or/Clp/archive/refs/tags/releases/1.17.11.tar.gz"
  sha256 "2c078e174dc1a7a308e091b6256fb34b4017897fc140ea707ba207b2913ea46d"
  license "EPL-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{^(?:releases/)?v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "79af2ec608ace169745abb6b7ddbc526e83dfd71ff8d82f29e6967d1fa901608"
    sha256 cellar: :any,                 arm64_sequoia: "b0f8a10b70873de63db3e2c6850321915a9cea60665dfddd74cf33f76157de15"
    sha256 cellar: :any,                 arm64_sonoma:  "7346550b69baabecb212dfcc9f68bfd943eeda761ad95bddcaff182e9abd5250"
    sha256 cellar: :any,                 sonoma:        "0abb7f3e110503e1b6c5aff68b560c63f05e35197bcbc1cd444e4df6562e93bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39ce002138ea1154a4ba77ef7f6af8f8f02a17cb2dc9e57660850eeba4707010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb90dd6fff07c7726f13e3e5c1549ed5db0a3852c22430663ab2cc089b942259"
  end

  depends_on "pkgconf" => [:build, :test]
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
      "--disable-silent-rules",
      "--includedir=#{include}/clp",
      "--with-blas-incdir=#{Formula["openblas"].opt_include}",
      "--with-blas-lib=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--with-lapack-incdir=#{Formula["openblas"].opt_include}",
      "--with-lapack-lib=-L#{Formula["openblas"].opt_lib} -lopenblas",
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    resource("coin-or-tools-data-sample-p0033-mps").stage testpath
    system bin/"clp", "-import", testpath/"p0033.mps", "-primals"
    (testpath/"test.cpp").write <<~CPP
      #include <ClpSimplex.hpp>
      int main() {
        ClpSimplex model;
        int status = model.readMps("#{testpath}/p0033.mps", true);
        if (status != 0) { return status; }
        status = model.primal();
        return status;
      }
    CPP
    pkg_config_flags = shell_output("pkg-config --cflags --libs clp").chomp.split
    system ENV.cxx, "test.cpp", *pkg_config_flags
    system "./a.out"
  end
end
