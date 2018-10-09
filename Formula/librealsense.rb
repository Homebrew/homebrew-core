class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.16.1.tar.gz"
  sha256 "001787d51398160a4b9285ffa74df08e22615a8278a3c994fc55c1584644584a"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "6d022b620dba1d4dd4bba5c9c58a6a495b48034a33078422d26c8baba68f22c1" => :mojave
    sha256 "fbbab4b7cfe5b7bbe66eed0be2e2e9b762b291be662171830290b28739977312" => :high_sierra
    sha256 "a879f90b71c7765504d09c3dae98dde51ee51af509e8d827a8f5b1117d92d15e" => :sierra
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
