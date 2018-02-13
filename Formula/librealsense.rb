class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.10.0.tar.gz"
  sha256 "d43804d9a09c7c077a77577d19f624cfb2f923c3c92d76cced4299b62f09436e"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "6b782f7de4806dc4f88b685bac60f635c1b4814e363728d1512c6b795e630c5b" => :high_sierra
    sha256 "a1848830b60d26f1950666567ac16d1d2eaf0078b017a62e1ff53c5d24d11b72" => :sierra
    sha256 "829300872c0f6dab4b90dfb9ab49a536301ec6db7f39fad19044f9c4f3f049d3" => :el_capitan
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
