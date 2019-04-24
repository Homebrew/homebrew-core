class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.21.0.tar.gz"
  sha256 "ebe553668ae70ad776b2a6ac0c1e6f636dc0dc50bacfe09c3caa86f17f7bd825"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "3425d76933db3dc75233992a0f2c03799c6c5635091ad30d9d4310cf0f3fe99b" => :mojave
    sha256 "5de3445aeaaf4ab49e58230bd47d65ecd491a07a9424e0b25254d350fa76a20f" => :high_sierra
    sha256 "3e10079509e9acff3ddfcbb508f0325d1bae5aeaa3457b24993e2fda85993e60" => :sierra
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
