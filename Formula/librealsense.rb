class Librealsense < Formula
  desc "Camera capture for Intel RealSense F200, SR300 and R200"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.8.3.tar.gz"
  sha256 "4b99e684d047089e6b641ed1975ee50f862e7ea56280466ab7d8cb822627cdc6"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "3509c5d9d563e6db458166816331ac1a86f790fc7cd0ccc1d58fd7ac57b49edb" => :high_sierra
    sha256 "7c8d47e698f30527724f1f44c1b1fbfed0465afec43cef59c0ff1f51772721ce" => :sierra
    sha256 "2ccabb3e828fa7dd9df88a8dcd590139d96686965468b85851924b27b880ea4c" => :el_capitan
  end

  option "with-examples", "Install examples"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glfw" if build.with? "examples"
  depends_on "libusb"

  def install
    args = std_cmake_args

    args << "-DBUILD_EXAMPLES=OFF" if build.without? "examples"

    system "cmake", ".", "-DBUILD_WITH_OPENMP=OFF", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librealsense2/rs.h>
      #include<stdio.h>
      int main()
      {
        printf(RS2_API_VERSION_STR);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal shell_output("./test").strip, version.to_s
  end
end
