class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.11.1.tar.gz"
  sha256 "0a5eabe194555796b2c552bdbbb9227566bbce5eb95167a40021dad32b27e565"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "ec874e3edd8d8b6ddc9404fffd1625ed394f5457afc8139edbfda4fd47b12954" => :high_sierra
    sha256 "23fb42e12a00d6c05186e215c5db07dcb08c6f675567d1df3c100325e56dbd60" => :sierra
    sha256 "d41640188b58c0b29351fd24d7308e50903fdc6bac0804ff058d421709a74b40" => :el_capitan
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
