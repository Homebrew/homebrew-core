class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.33.1.tar.gz"
  sha256 "d157c861b6bdeb2833e02c3d287a2f071f52e5fed3d37f04b94ec014b8f35994"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "41478d8c11d34377795622ba0bc22f332e2dc207c40620f7787af75aeda88139" => :catalina
    sha256 "957344fb34c1042b264bb5396b727b4d4a09a158d98b41e8ee4d362c60f0f16f" => :mojave
    sha256 "f86573c6e7392aed46eb3a02b10d7f7d0725612d43d20e6ae052c92ff2c24148" => :high_sierra
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
