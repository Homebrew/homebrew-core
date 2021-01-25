class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.41.0.tar.gz"
  sha256 "18795fb21cc7d35de047b99da36a8c7a7521aa9e3dac2eda4937edf2b92774cd"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "3da55d78a83912c8bd8188874c103d3ae6d9c910313f2e50c9e04801cb2bd09f" => :big_sur
    sha256 "7e872a8845a128c6c2ce50172eb69ed98c1fb7f4554bfce35e1efa31efeb0b33" => :catalina
    sha256 "9feb0fbb2ea091904af8dd6219f61ba6ccb35e128fa4e4131189d7327f5fe2eb" => :mojave
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
