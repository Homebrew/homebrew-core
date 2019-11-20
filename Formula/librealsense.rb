class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.30.1.tar.gz"
  sha256 "379c2b8248b1f550222dcf0fbfb1d77037014a7d8e3ae9265d599b3d3f177c11"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "afe07eb7cd8ca19b9bf53b02028d62f72561115bf7a188eba0d42069f6042d95" => :catalina
    sha256 "f719b5688709783d5a7397e7e8a7a0ca81c2ec262029684e131ecbcba7b30c77" => :mojave
    sha256 "c34e01e6844cb06497b5f89effd61b21c7f942973a50792d338922e434765197" => :high_sierra
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
