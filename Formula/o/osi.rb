class Osi < Formula
  desc "Open Solver Interface"
  homepage "https://github.com/coin-or/Osi"
  url "https://github.com/coin-or/Osi/archive/refs/tags/releases/0.108.10.tar.gz"
  sha256 "614c2b329caf57c00326412266299fdfd93c5691492034fbb46990b5e71cc5a7"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "69ddf7a23bba809d9441015863497c1d3d0e0ddcdddaefaff7944bd4a7132a73"
    sha256 cellar: :any,                 arm64_ventura:  "389be0113a8ce6ba6029c02349f741c64545c17e005a4c12a5f45b1c82cb70a0"
    sha256 cellar: :any,                 arm64_monterey: "8d385949e281b7def59a9e58eb167dbbb1b5b5c2722ce1e283a2c388976c88c2"
    sha256 cellar: :any,                 sonoma:         "54aa80a08f1ee551ba675399b4f32566e6863d7ab27b48f29c7a9edee3a0acc1"
    sha256 cellar: :any,                 ventura:        "cf9bfa64985fccad356d97a647c86ef7a83ef970a57ea6bf0c66ca1a1697441b"
    sha256 cellar: :any,                 monterey:       "e46614c22e5b59f788fba4ca37825f136341664659105c027ad5c6219ae287ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e86dd7bc283f1cd8b3026074e78e6cf17267557325d0ce547bc95ff3c4573aaa"
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
