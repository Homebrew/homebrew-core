class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.17.1.tar.gz"
  sha256 "438fc35cca150d1cd9e6633d6212cc6970b738e1fd13c40343874e67bed2cbeb"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "265da42df1c161126b14aaab7d0cebf63f6feed8d52cbe316aa741a5bdc95ff1" => :mojave
    sha256 "db78162b1b2a633246c1d25be878c40326894985993e730145a3e866f6396786" => :high_sierra
    sha256 "4be9367999cbd9caf1d538d7559f10df0b3e32db68bd9f31b85dcece09175dfc" => :sierra
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
