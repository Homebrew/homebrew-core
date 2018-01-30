class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.9.1.tar.gz"
  sha256 "9c1698c93de5c695f839bac935baffacf2c9b002fe807de8fbe1f31d39b8d0ac"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "c0adad963dc5da4cda3b683256530fd42725148a2737b43fd7b0c1fe4d7e3cca" => :high_sierra
    sha256 "19e075df89186a74e3bc8bb5f3840650b72df40538fc178b2b9a5bb53ab15e67" => :sierra
    sha256 "9341aa22d65250a1241dff601b429d8c02dfb92e8e2bb4103f0ba3a84d280eea" => :el_capitan
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
