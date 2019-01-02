class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.17.1.tar.gz"
  sha256 "438fc35cca150d1cd9e6633d6212cc6970b738e1fd13c40343874e67bed2cbeb"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "264af4455ac862646e77ccbe812869bcaa42a9f6935130bb58b379e12771c87f" => :mojave
    sha256 "32177c36ea8f3088d5f89f8da726039595151f515c8a69bae63b0494ddf6def2" => :high_sierra
    sha256 "fdec9f104082742dde420ebadbb01175dd9e9b410c363366b1255a4c9e46b156" => :sierra
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
