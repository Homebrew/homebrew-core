class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.22.0.tar.gz"
  sha256 "bdaaedc72546ccd24e004bba83a44b165f0ba571f88ccb53574b92eacce66f2d"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "112a229f6b6431227de26ff907f765e235631f120f3e054b5ff213a83f0ce17d" => :mojave
    sha256 "4dec7e2a33a6e009243c27546bd710967fdaf8a89e48f0789ff69a1cfcecd85f" => :high_sierra
    sha256 "4460ec5ffa6f6fdb86c35d70727a618977ee888ffeb74818c4544cf68ec3b25a" => :sierra
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
