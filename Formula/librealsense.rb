class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.28.0.tar.gz"
  sha256 "2a74dc5a25a469faad09b9784440927dfad9142e90ccc04249d9478a3cde00e0"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "a3f29e8deb5735c040cc17b4802f2920a57a57732ca4754cd47908f0d2e4840e" => :mojave
    sha256 "7fb7c0a564eb7762c9252f8f7518709c9f66be9d46288fed65336d0da50c1f9e" => :high_sierra
    sha256 "2c1f4e9e2eadc21ab2dec772babaa27225b645870d879ae039ba9c89deb3d7be" => :sierra
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
