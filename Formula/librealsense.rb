class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.16.5.tar.gz"
  sha256 "94d7da2ab7925977011efba2bd75bf3d354ed4bced3c5407321d8eaff6628ed1"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "76a41f0e2e8c2e3e482cc9312beb4a226c51ca402a8642cc6cb02ca69ac3822e" => :mojave
    sha256 "e95f607498c4d96544645f99ff0e3824f56ae9a22cc20c597c5d5a5669e2479c" => :high_sierra
    sha256 "2e1b3372a730674cd2fad2bc06db35f33888bb7905cc70ec2ee99d8a28d794d7" => :sierra
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
