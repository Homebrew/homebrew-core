class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.14.1.tar.gz"
  sha256 "153aa563265c37e29ac00ab06c2e8affa285e4606488605d688ef274993e9485"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "29064cc84e9253a7d51a7fc26c24495eb56f5e9235dc18e5e2eae3214eba05a2" => :high_sierra
    sha256 "1e8a43ad0fc7a653b0e099a9bb43dbe302b0ec3ad9d6cdff941ee28199b07a81" => :sierra
    sha256 "eb5df67af149d585a4d723ec28f32cb70435de25ff94122f97dfb82ef2df04d6" => :el_capitan
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
