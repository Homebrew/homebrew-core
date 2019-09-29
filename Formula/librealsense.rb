class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.29.0.tar.gz"
  sha256 "5dafabd13fe3ed23ae6c1f6c7f0c902de580f3a60a8b646e9868f7edc962abf2"
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
