class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.23.0.tar.gz"
  sha256 "40d6c8a465eeb6802a40b79c708300328da55ca4d3d2578ec3be534d1ae7e829"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "eecd6aef888909312b971d128869f74f6e1b82ffc04d93e14661448ae075634e" => :mojave
    sha256 "201347e6ae34a1dfa0dbec0723859609a8f68472c97f4b91bacba75fc13a9cbb" => :high_sierra
    sha256 "93df45a1dbd14dc3ba68f25bdb55526fcd60d64776b7671398e1f0302d6d57df" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glfw"
  depends_on "libusb"

  def install
    args = std_cmake_args
    args << "-DENABLE_CCACHE=OFF"

    system "cmake", ".", "-DBUILD_WITH_OPENMP=OFF", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librealsense2/rs.h>
      #include <stdio.h>
      int main()
      {
        printf(RS2_API_VERSION_STR);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal version.to_s, shell_output("./test").strip
  end
end
