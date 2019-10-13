class CBlosc < Formula
  desc "Blocking, shuffling and loss-less compression library"
  homepage "http://blosc.org/"
  url "https://github.com/Blosc/c-blosc/archive/v1.17.0.tar.gz"
  sha256 "75d98c752b8cf0d4a6380a3089d56523f175b0afa2d0cf724a1bd0a1a8f975a4"

  bottle do
    cellar :any
    sha256 "94043450fac7a32fb15bec298a53b6fd486ac082c4e04b06ed3f1541aa8a625e" => :catalina
    sha256 "6b0d57fbcd25dea36dbbb13d6fe520b3f536a3ff36aebb1c087eb73f46a7178e" => :mojave
    sha256 "3f4a4438e79820e9a0d00ff29ed87e8f74ee6d208a51cebf6226a73e20714791" => :high_sierra
    sha256 "bfdec00e2a65af3899b79182ea64cd02d8669edb1fd9332928a862057f3d2aa9" => :sierra
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
