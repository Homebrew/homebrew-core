class CBlosc < Formula
  desc "Blocking, shuffling and loss-less compression library"
  homepage "https://blosc.org/"
  url "https://github.com/Blosc/c-blosc/archive/v1.21.0.tar.gz"
  sha256 "b0ef4fda82a1d9cbd11e0f4b9685abf14372db51703c595ecd4d76001a8b342d"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "e07d3e94bb0df9c9dad09f7093eac90fea34b22cd2f75a0ab8448e912d88ac07" => :big_sur
    sha256 "6c256c5a6dd6a63e9cbc975fc1eb10e12f416b612c6513b71991b27f00ddbcd1" => :arm64_big_sur
    sha256 "217d36ff72906927ce554e653c700d9cde7a6f83d1698dc3b46a019c2ed7dfc6" => :catalina
    sha256 "4c52001ce5acf5b8f0c02563be063537788ba043c3c55badd10d8da618b7325d" => :mojave
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
