class CBlosc < Formula
  desc "Blocking, shuffling and loss-less compression library"
  homepage "https://blosc.org/"
  url "https://github.com/Blosc/c-blosc/archive/v1.20.1.tar.gz"
  sha256 "42c4d3fcce52af9f8e2078f8f57681bfc711706a3330cb72b9b39e05ae18a413"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "64299f26d77e25470481bf817cb5a37589e30646a22b38c0d400d5bde10565a8" => :catalina
    sha256 "7772266cb93fb92f9815c14ef5a28c6a0c4ca777eb639f1b04a46d02cd19b5e5" => :mojave
    sha256 "8c91b7d9d3977f8e9d1d95a58b7f907f3091320ef6b52dcdacc3b53fa1575a0f" => :high_sierra
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
