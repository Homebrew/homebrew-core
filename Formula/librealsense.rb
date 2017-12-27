class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.9.0.tar.gz"
  sha256 "851bab01eb5c4e5d33fe0759197e6f89b7406da277b7a272016a0b47306ccff1"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "3509c5d9d563e6db458166816331ac1a86f790fc7cd0ccc1d58fd7ac57b49edb" => :high_sierra
    sha256 "7c8d47e698f30527724f1f44c1b1fbfed0465afec43cef59c0ff1f51772721ce" => :sierra
    sha256 "2ccabb3e828fa7dd9df88a8dcd590139d96686965468b85851924b27b880ea4c" => :el_capitan
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
