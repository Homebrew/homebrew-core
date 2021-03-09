class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.42.0.tar.gz"
  sha256 "bcf8094cc8e2c72bf99e7fef22a334424e4d7bfd9fcaa8c52309eba665b14248"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, big_sur:  "93a88d4c763eb4fd5bb1e589c5f8ae8fa140f1bc902b0ef5794857a4f8ca1061"
    sha256 cellar: :any, catalina: "04fe5fffebab683c2f2864678a643227683f8bfa5a419f0df8c96e2deeb419b5"
    sha256 cellar: :any, mojave:   "d19bfc833f65e43791388cc24b09ff5e581aaf72c74eee3385a2dc7dab25a663"
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
