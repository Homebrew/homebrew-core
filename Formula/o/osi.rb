class Osi < Formula
  desc "Open Solver Interface"
  homepage "https://github.com/coin-or/Osi"
  url "https://github.com/coin-or/Osi/archive/refs/tags/releases/0.108.9.tar.gz"
  sha256 "8b09802960d7d4fd9579b3e4320bfb36e7f8dca5e5094bf1f5edf1b7003f5562"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1b4a807addf9f40d64a208be6122d2b804363824c65b8ffb8da3eec8ac3741fd"
    sha256 cellar: :any,                 arm64_ventura:  "d553f6352d8d3aa1cb29eb616a2ea71bc2bb4d5da7e4bfa38a833ed9d5b4e142"
    sha256 cellar: :any,                 arm64_monterey: "13f6987eb58a6eb065d331e49e2c55e2c468f7793a930d010cf4a0157256fcfa"
    sha256 cellar: :any,                 sonoma:         "73a8f48411ee84c77897ce180577513500811384d5f91a21d75f5fca8c621be7"
    sha256 cellar: :any,                 ventura:        "2d13fc32b0062fbc65b2d7cc39524c1274577d37a1d30903bba94f55f605604b"
    sha256 cellar: :any,                 monterey:       "21b58eb4d5e7a3de57aa33ebccec4b265938fd03287916614eb6b7b6607889d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f3586bd6e32fb870e2c2f413105b446f00257bcbcd70a724632132c6d3ccece"
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
