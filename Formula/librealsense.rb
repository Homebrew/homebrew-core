class Librealsense < Formula
  desc "Camera capture for Intel RealSense F200, SR300 and R200"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v1.12.1.tar.gz"
  sha256 "62fb4afac289ad7e25c81b6be584ee275f3d4d3742468dc7d80222ee2e4671bd"

  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "6d7b2b1f63606818bdbc0f8e1db5b36b3add1e2171fada3c8abced7b5a606f37" => :high_sierra
    sha256 "3076d299219ddee4b4b11e68238f339fc6f1b85f2acc360e11d815b85ed6a577" => :sierra
    sha256 "ee7fe9916adcdca8fbea9a2bfc9f90662db0fbe8ec94c61ef6342eb2ec27775d" => :el_capitan
    sha256 "36faefdb0a151dfbd090ce80c4e0692bde78b9ee4a1cde7bdd8ab82f15f96dae" => :yosemite
  end

  option "with-examples", "Install examples"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glfw" if build.with? "examples"
  depends_on "libusb"

  def install
    args = std_cmake_args

    args << "-DBUILD_EXAMPLES=true" if build.with? "examples"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librealsense/rs.h>
      #include<stdio.h>
      int main()
      {
        printf(RS_API_VERSION_STR);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal shell_output("./test").strip, version.to_s
  end
end
