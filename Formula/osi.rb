class Osi < Formula
  desc "Open Solver Interface"
  homepage "https://github.com/coin-or/Osi"
  url "https://github.com/coin-or/Osi/archive/releases/0.108.6.tar.gz"
  sha256 "984a5886825e2da9bf44d8a665f4b92812f0700e451c12baf9883eaa2315fad5"
  license "EPL-1.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "3f71fca3511681f252f956752dbbe314d216de7a0ff40c7c56505ac6292d91a5"
    sha256 cellar: :any,                 monterey:      "ae4776cd0fec3b811783b85f3c30863e79015671309d0db590b36686e0bab859"
    sha256 cellar: :any,                 big_sur:       "ca309667b17ad26cb79ba1305f096bf3163d1858658030ef21ae3cf23a3495f3"
    sha256 cellar: :any,                 catalina:      "448319c96791abd303e976711176d74260d575b528c5c1229e1439fb85c295b9"
    sha256 cellar: :any,                 mojave:        "a21200a175b4d0a2208be0e34fb2dd64965133be04b30db7150cf55fe46093e4"
    sha256 cellar: :any,                 high_sierra:   "4fb8d7a49968da18a979df560dde2c8cae711c37ad722af8a0c20c3a7980134d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35126891d80a9116cc45c44fe5afe3c993fcb1eb5dda15f2e2ac568d67510bea"
  end

  depends_on "pkg-config" => :build
  depends_on "coinutils"

  def install
    # Work around - same as clp formula
    # Error 1: "mkdir: #{include}/osi/coin: File exists."
    mkdir include/"osi/coin"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--includedir=#{include}/osi"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <OsiSolverInterface.hpp>
      int main() {
        OsiSolverInterface *si;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lOsi",
                    "-I#{include}/osi/coin",
                    "-I#{Formula["coinutils"].include}/coinutils/coin",
                    "-o", "test"
    system "./test"
  end
end
