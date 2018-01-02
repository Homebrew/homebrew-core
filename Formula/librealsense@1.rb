class LibrealsenseAT1 < Formula
  desc "Intel RealSense F200, SR300, R200, LR200 and ZR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense/tree/legacy"
  url "https://github.com/IntelRealSense/librealsense/archive/v1.12.1.tar.gz"
  sha256 "62fb4afac289ad7e25c81b6be584ee275f3d4d3742468dc7d80222ee2e4671bd"
  head "https://github.com/IntelRealSense/librealsense.git", :branch => "legacy"

  bottle do
    cellar :any
    sha256 "6b085438da80732be8e7bea29cce84b6c8a2f6210819b5b735c2eaaced57ee56" => :high_sierra
    sha256 "74f0a2f61d3d65f210412603445969d08de12808121e4dba7a71f1eb5831075f" => :sierra
    sha256 "97a1d82d970a67bd1c8d10122a3e939909ea1e5ed4320e1f564da51a4e5456d1" => :el_capitan
  end

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
