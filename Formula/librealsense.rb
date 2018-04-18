class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.10.4.tar.gz"
  sha256 "b0c1999686fd05c004a79ef850c04d0cf08171b9217101034c1a349113264b1e"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "35e73cd841ea78081aed4b0c3689a47540edfcf478fafd250be8f18395f8ca96" => :high_sierra
    sha256 "ac508f59c6958dd8675f92a6896cacab29346632102ecc5f05e0f1652155816d" => :sierra
    sha256 "e8c3cfc40e8e9e1ed3c60bd118633dcebad6763ca66c7f7e8a10c46caf84ec2d" => :el_capitan
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
