class CBlosc < Formula
  desc "Blocking, shuffling and loss-less compression library"
  homepage "http://blosc.org/"
  url "https://github.com/Blosc/c-blosc/archive/v1.17.0.tar.gz"
  sha256 "75d98c752b8cf0d4a6380a3089d56523f175b0afa2d0cf724a1bd0a1a8f975a4"

  bottle do
    cellar :any
    sha256 "803654ccc5c592364ad7ede6d719e9b8e04ab3db2ed80bfde0a1d3d6c183ee90" => :mojave
    sha256 "2490504b4dd8181c3b745a89110ca8b211e24d90fe37be2636f3d7176787bc60" => :high_sierra
    sha256 "386026371f549b24e0b7ca2e6a624199d3400a2b8ea42f6fb83bdb6c34119a6a" => :sierra
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
