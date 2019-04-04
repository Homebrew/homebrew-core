class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.20.0.tar.gz"
  sha256 "01824767d8fb933f9487e97d50a941594abd18b6140c5c864bbf0db22dc62115"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "99996c85684fe60816a10102e53476a0525d432808935864c58c6444e9184ea5" => :mojave
    sha256 "bb50802db26325be3011411c2d95e368643c1260e0b27a70a2633c4e90a9673b" => :high_sierra
    sha256 "ae75a744c52caa3f7dc283456157b56ebc8b4bdec8c30c761a4afa9ed1e617e8" => :sierra
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
