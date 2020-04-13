class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.34.0.tar.gz"
  sha256 "130e38f759dbe420ef531cf7c1587f50161f4f4de4d3b008f569abd6d404dc23"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "df8a4e7336afc7b622952ca3735cada4b2589256a505378b95bee38b2799eb46" => :catalina
    sha256 "22f1b0378a38911ca8ea978f4f93eaa7de9a8bffdc498be625dbdb633bd5041d" => :mojave
    sha256 "1cf821c13b00c3e349902041c76ed45dc8a72dce042ccbe2b0c8f6364fb3d524" => :high_sierra
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
