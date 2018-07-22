class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.13.0.tar.gz"
  sha256 "3f5dd4a98484ad51b802ebe2de61f3c39201bf1c1302f85e970c8f3126e4b34a"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "2ec8fe8e3ded3dbd201cce61cf7de9ebc43fe93d10158ab860a3ef7c05d3ef9b" => :high_sierra
    sha256 "2ee5692751518894eb52851cb6cb0859107e90bc8c5631fab3930038d99cfa1e" => :sierra
    sha256 "4fe69580ee74ba25e6a1787118d2e6c24feedeb8da6af8f7237e3fe3fe93fcb3" => :el_capitan
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
