class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.31.0.tar.gz"
  sha256 "c8af36a3ccac35e13fa8f9188d3a780003a853ac9c2e10c77c60a312aab71aeb"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "a2a38617047d44e6731ef1207dfbf181f3430ad73c1d13304f75725d311053f9" => :catalina
    sha256 "94352d8ece6b644d5844a207abd3819df0e35fd2395232c881c790c11d6b2b1c" => :mojave
    sha256 "b087460234a8045b2f1bbd6ce6b77b4d757991a225e46df8d7c2a08068922582" => :high_sierra
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
