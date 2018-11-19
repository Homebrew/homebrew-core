class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.16.5.tar.gz"
  sha256 "94d7da2ab7925977011efba2bd75bf3d354ed4bced3c5407321d8eaff6628ed1"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "e12a1e091ea120fa10673e1bb80ecfdba7aa6b30d9e8cf266480f36106aeb1e6" => :mojave
    sha256 "f3a99629a6fb667ae6c7cb43cbbbe446032e986319fe722192940ad5b0c02dc2" => :high_sierra
    sha256 "eda9dcf15c94ebd8c11b0f92a9f95dd20854a32e12ea897edb18f8f0c5e6791c" => :sierra
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
