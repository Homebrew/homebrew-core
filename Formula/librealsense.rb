class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.29.0.tar.gz"
  sha256 "5dafabd13fe3ed23ae6c1f6c7f0c902de580f3a60a8b646e9868f7edc962abf2"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "9f4e6113e75b15478bc1699f0206d091a22eec68f9bb6fa09e089d8c215e10d5" => :catalina
    sha256 "49ef36eef3b6fb4ae9ad0fdbe618221ee48bf829896546791ad371bf6462f1de" => :mojave
    sha256 "fca011988bf82cdd0ea3fa923197556c16ef7ec8c2102fb17ed97f08c2e2d6e2" => :high_sierra
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
