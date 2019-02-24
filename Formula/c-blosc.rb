class CBlosc < Formula
  desc "Blocking, shuffling and loss-less compression library"
  homepage "http://blosc.org/"
  url "https://github.com/Blosc/c-blosc/archive/v1.16.2.tar.gz"
  sha256 "3a45689a425b740f7d4afb27ec53b0df480dd330419cc9c971c81da638155e96"

  bottle do
    cellar :any
    sha256 "51df9dc2043e8bc48b89734da8cfdcf8c68a92d35f18ee960fd7a9a3fd0b0bfc" => :mojave
    sha256 "f9485bcd4cb681e30a2df2505a54196e7ecab3c6eceb75f0ec97ac4aa5261d01" => :high_sierra
    sha256 "9625ec4aeccb3804a56e6908d7b2e4a409819a5d42ffa778b4d79744014de1e4" => :sierra
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
