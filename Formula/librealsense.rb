class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.19.1.tar.gz"
  sha256 "6c93c5680146c86951a6a65b59e0fdef02406afcec85c153f700227cd9b6c758"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "b60d83a62eb82c408e07ac5a5d804747c76db4076f66ad5cc0ebf7b995666dd3" => :mojave
    sha256 "9c463f77f59a273a5afe7eb65ceaf275594c1a62dc9f0bf333ba5500b427086d" => :high_sierra
    sha256 "f9afdcb4bd0a92beeed2181008f26f476e5f5c0379f910c52f3e206b02451c43" => :sierra
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
