class Osi < Formula
  desc "Open Solver Interface"
  homepage "https://github.com/coin-or/Osi"
  url "https://github.com/coin-or/Osi/archive/releases/0.108.7.tar.gz"
  sha256 "f1bc53a498585f508d3f8d74792440a30a83c8bc934d0c8ecf8cd8bc0e486228"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "00e15cdc872303ab7191a5e8dc3a7f1957242445c817f574c49868a18412baf2"
    sha256 cellar: :any,                 arm64_monterey: "a7f8834fcb5eeaedc2e0486bcc9e7278fc9fbd6cf7c4c7065052a2f26e419896"
    sha256 cellar: :any,                 arm64_big_sur:  "523fd267a8e74cafbd9715ba43541bdc1c845d252ae2da4b9e540151fffdf883"
    sha256 cellar: :any,                 ventura:        "78b58cb8e83d08780fcfd5bd857e6779ddfc8c1a429befc64af8710436a5a95c"
    sha256 cellar: :any,                 monterey:       "91b6c7116bf28d34ae2fa191dcc70e7d2ac1deec388e8ce4e029c08a89dbfe53"
    sha256 cellar: :any,                 big_sur:        "f17d643090146679a789ac4697d02e4e743b32ee6321df26d2a4757c4a993b33"
    sha256 cellar: :any,                 catalina:       "bc31d0b172cab7d118dfde30e5422f35eb26810d1cc3c18ef6b040775f8f0486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d69bb7c0fa92df9db72f439e5c1de021fad1623ad7d23c75b6f74fc8b7dc9a6e"
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
