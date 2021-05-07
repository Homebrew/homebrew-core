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
    sha256 cellar: :any, big_sur:  "4e8b518b9d5674f3fd8772f0072f33f3068ac3815005ba9d4b9728091a44e60b"
    sha256 cellar: :any, catalina: "3e2e9dad9d11b5055b1499d169bd47d24da57303a352844fb069ff19f9e570a8"
    sha256 cellar: :any, mojave:   "05713870dfad3d5a5d2255c0234b6979b65b47bec7b139a47c8a4c67efd5a85d"
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
