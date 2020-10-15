class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.38.1.tar.gz"
  sha256 "77524946ad6fbd672e74c95f4970462817264be882fd532125bc98069fe39f19"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git"

  livecheck do
    url "https://github.com/IntelRealSense/librealsense/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "8f20d1356329202cccf31a28df496f23910f67785e65b4568fdcc79238b36b4a" => :catalina
    sha256 "4bcfe0157d4ef4b35a439bf0e9821278bdb8cd159eca7fcc22a85ce60a3a79ef" => :mojave
    sha256 "2b5992dd5703a538e6f95f9ec0a9d721688db310551bf7f24415d2c2b769bc80" => :high_sierra
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
