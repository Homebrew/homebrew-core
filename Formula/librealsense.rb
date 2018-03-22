class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.10.2.tar.gz"
  sha256 "d5c52c82902e6c658ca63eeb43d671aa8181ad3751463ed3ce784c8462443772"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "e4835838b9644c5919180c69c3d26adef3875d82ad17ce1db21bbec1c5d91f5b" => :high_sierra
    sha256 "0e96e36012b5354cf51cb28d0ec26bc3047c69d461c07a9b4b50490921aa6f9a" => :sierra
    sha256 "e6d447d94f71a710b39d8b68c5af1604c103bc2699d4363158b1211af6044f90" => :el_capitan
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
