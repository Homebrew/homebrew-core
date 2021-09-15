class CBlosc < Formula
  desc "Blocking, shuffling and loss-less compression library"
  homepage "https://blosc.org/"
  url "https://github.com/Blosc/c-blosc/archive/v1.21.0.tar.gz"
  sha256 "b0ef4fda82a1d9cbd11e0f4b9685abf14372db51703c595ecd4d76001a8b342d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "6c256c5a6dd6a63e9cbc975fc1eb10e12f416b612c6513b71991b27f00ddbcd1"
    sha256 cellar: :any,                 big_sur:       "e07d3e94bb0df9c9dad09f7093eac90fea34b22cd2f75a0ab8448e912d88ac07"
    sha256 cellar: :any,                 catalina:      "217d36ff72906927ce554e653c700d9cde7a6f83d1698dc3b46a019c2ed7dfc6"
    sha256 cellar: :any,                 mojave:        "4c52001ce5acf5b8f0c02563be063537788ba043c3c55badd10d8da618b7325d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a536055c8966b86a5aae7197e0404831b12bea28add1b6d050e21a3d9975c63"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <blosc.h>
      int main() {
        blosc_init();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lblosc", "-o", "test"
    system "./test"
  end
end
