class Osi < Formula
  desc "Open Solver Interface"
  homepage "https://github.com/coin-or/Osi"
  url "https://github.com/coin-or/Osi/archive/refs/tags/releases/0.108.12.tar.gz"
  sha256 "1d80d0b4275f2e1ceefc6dda66b8616e3a8c8b07a926ef4456db4a0d55249333"
  license "EPL-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0d215e7ad0f3a078c75cce63ecb8251cf894f48277c6f13c0ccc743f4ade0916"
    sha256 cellar: :any,                 arm64_sequoia: "f5abb88e0d063c5cfe7eef120ff21afc5e12716a52298fd6f66df79328bdb27d"
    sha256 cellar: :any,                 arm64_sonoma:  "fe7f58a5520c9a7b283ec86dffff13eebb97fa4e9f703b37bf39a79fe883091d"
    sha256 cellar: :any,                 sonoma:        "7378c5f7af3af543edac9c323582ac7fc7ec55faa793ea1c03d432a8c15aa27f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bf910c306aabca83e0e51bd03b0de37eddd2ab47d86a8512326c4e1121db0dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51a5f1fa24bde3164a6fbb181b77a2a5a34391aac49c7619499bfd946e0e7dd2"
  end

  depends_on "pkgconf" => :build
  depends_on "coinutils"

  on_macos do
    depends_on "openblas"
  end

  def install
    # Work around - same as clp formula
    # Error 1: "mkdir: #{include}/osi/coin: File exists."
    mkdir include/"osi/coin"

    system "./configure", "--disable-silent-rules", "--includedir=#{include}/osi", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <OsiSolverInterface.hpp>

      int main() {
        OsiSolverInterface *si;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lOsi",
                    "-I#{include}/osi/coin",
                    "-I#{Formula["coinutils"].include}/coinutils/coin",
                    "-o", "test"
    system "./test"
  end
end
