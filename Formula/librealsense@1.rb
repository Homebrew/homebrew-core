class LibrealsenseAT1 < Formula
  desc "Intel RealSense F200, SR300, R200, LR200 and ZR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense/tree/legacy"
  url "https://github.com/IntelRealSense/librealsense/archive/v1.12.1.tar.gz"
  sha256 "62fb4afac289ad7e25c81b6be584ee275f3d4d3742468dc7d80222ee2e4671bd"
  head "https://github.com/IntelRealSense/librealsense.git", :branch => "legacy"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glfw"
  depends_on "libusb"

  def install
    system "cmake", "-DBUILD_EXAMPLES=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librealsense/rs.h>
      #include <stdio.h>
      int main()
      {
        printf(RS_API_VERSION_STR);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal version.to_s, shell_output("./test").strip
  end
end
