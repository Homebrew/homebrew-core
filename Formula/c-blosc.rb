class CBlosc < Formula
  desc "Blocking, shuffling and loss-less compression library"
  homepage "https://blosc.org/"
  url "https://github.com/Blosc/c-blosc/archive/v1.17.1.tar.gz"
  sha256 "19a6948b579c27e8ac440b4f077f99fc90e7292b1d9cb896bec0fd781d68fba2"

  bottle do
    cellar :any
    sha256 "4896df1cf1f325a0499f55801d5c9cace67ce4234e029532a1a5acb912bb8a12" => :catalina
    sha256 "fd241bcebdb57fa54ffb06ab55f0f59cb213346e7d9f217a7aece1a4317cec6f" => :mojave
    sha256 "8f961c2826d79cc0e80a5154896120d05ccd57621dbfb1257349979e9ce4ddf3" => :high_sierra
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
