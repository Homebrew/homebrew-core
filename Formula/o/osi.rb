class Osi < Formula
  desc "Open Solver Interface"
  homepage "https://github.com/coin-or/Osi"
  url "https://github.com/coin-or/Osi/archive/releases/0.108.8.tar.gz"
  sha256 "8b01a49190cb260d4ce95aa7e3948a56c0917b106f138ec0a8544fadca71cf6a"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c8c3a725db022a6b778c5978cb0f75f52801178afd5a3b188e9b0e4da820b54b"
    sha256 cellar: :any,                 arm64_monterey: "6096f7d19bec96189b2952eb084868ad02929239d124e4cd64f75414d8c4653b"
    sha256 cellar: :any,                 arm64_big_sur:  "f5470a9e3c06da29cfba1b032114b80c7318db99a8012d3e4ad0712e0094e359"
    sha256 cellar: :any,                 ventura:        "52aed1baafbef0913c13b7d241c6ba4dadd245f36c41e4c86df17fd7aaced06c"
    sha256 cellar: :any,                 monterey:       "fa3fe31ee9b82b6587527183fed072899f708dc1b3cbb08f4c980d2ea2fdeb43"
    sha256 cellar: :any,                 big_sur:        "1c54abe37d8f2500077cd1ec1ba2ba9b447b46df75d80e76fda9a9088310a867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70dedde843f78011d381805f0da706d48bdd2a30143996efdd3d36de3f87d3e2"
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
