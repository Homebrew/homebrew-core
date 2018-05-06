class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.11.0.tar.gz"
  sha256 "8a90e5b935cb3d512e6fff0eaa5d22ff1bf350fe048ea102a69a8a7c2ddf9ee0"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "8fd080c1b6312e41676c180c75842c63cd1cb05997f95baa37bb9c104977279b" => :high_sierra
    sha256 "434845e2038e1bc60a822be2d9d9a9b5a54fc6cafcf5ba650408d5439c567ef3" => :sierra
    sha256 "55ff4e1eba88785498ab383d2717cbe228b2b899c46b93e4da4b388b7a183225" => :el_capitan
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
