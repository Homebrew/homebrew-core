class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.44.0.tar.gz"
  sha256 "5b0158592646984f0f7348da3783e2fb49e99308a97f2348fe3cc82c770c6dde"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, big_sur:  "54e95dddcbbc4659f5a1492ee451b26a454c78e3f7971551cc5def6d66be6d26"
    sha256 cellar: :any, catalina: "288689a9bc5a41847846b1f6142b54303a575f7ef518fb63ffc8c975ec524af8"
    sha256 cellar: :any, mojave:   "30a4fe7cc7fdbaf657a6416e75e4c44696ddb436bca379ef2846efd0864d9bb6"
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
