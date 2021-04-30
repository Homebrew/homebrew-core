class Opencv < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  url "https://github.com/opencv/opencv/archive/4.5.2.tar.gz"
  sha256 "ae258ed50aa039279c3d36afdea5c6ecf762515836b27871a8957c610d0424f8"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "bf52b176271698c7e2e4e9c5e042882c8049e4f1f327689077b9ec4e35e53b23"
    sha256 big_sur:       "13624f806d33bc40c4b49e8b552311611f83ef5ba9af79140aa53efe40a5dcaa"
    sha256 catalina:      "8df0308f01d98ec7037164b11a0058979a3ea084ded3132d5810eb315c2bf104"
    sha256 mojave:        "5ffe038e388394e57be95ad3b187a7f8823000b7fd87484aba70128453c15475"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ceres-solver"
  depends_on "eigen"
  depends_on "ffmpeg"
  depends_on "glog"
  depends_on "harfbuzz"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "numpy"
  depends_on "openblas"
  depends_on "openexr"
  depends_on "protobuf"
  depends_on "python@3.9"
  depends_on "tbb"
  depends_on "vtk"
  depends_on "webp"

  resource "contrib" do
    url "https://github.com/opencv/opencv_contrib/archive/4.5.2.tar.gz"
    sha256 "9f52fd3114ac464cb4c9a2a6a485c729a223afb57b9c24848484e55cef0b5c2a"
  end

  def install
    ENV.cxx11

    resource("contrib").stage buildpath/"opencv_contrib"

    # Avoid Accelerate.framework
    ENV["OpenBLAS_HOME"] = Formula["openblas"].opt_prefix

    # Reset PYTHONPATH, workaround for https://github.com/Homebrew/homebrew-science/pull/4885
    ENV.delete("PYTHONPATH")

    args = std_cmake_args + %W[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DBUILD_JASPER=OFF
      -DBUILD_JPEG=OFF
      -DBUILD_OPENEXR=OFF
      -DBUILD_PERF_TESTS=OFF
      -DBUILD_PNG=OFF
      -DBUILD_PROTOBUF=OFF
      -DBUILD_TESTS=OFF
      -DBUILD_TIFF=OFF
      -DBUILD_WEBP=OFF
      -DBUILD_ZLIB=OFF
      -DBUILD_opencv_hdf=OFF
      -DBUILD_opencv_java=OFF
      -DBUILD_opencv_text=ON
      -DOPENCV_ENABLE_NONFREE=ON
      -DOPENCV_EXTRA_MODULES_PATH=#{buildpath}/opencv_contrib/modules
      -DOPENCV_GENERATE_PKGCONFIG=ON
      -DPROTOBUF_UPDATE_FILES=ON
      -DWITH_1394=OFF
      -DWITH_CUDA=OFF
      -DWITH_EIGEN=ON
      -DWITH_FFMPEG=ON
      -DWITH_GPHOTO2=OFF
      -DWITH_GSTREAMER=OFF
      -DWITH_JASPER=OFF
      -DWITH_OPENEXR=ON
      -DWITH_OPENGL=OFF
      -DWITH_QT=OFF
      -DWITH_TBB=ON
      -DWITH_VTK=ON
      -DBUILD_opencv_python2=OFF
      -DBUILD_opencv_python3=ON
      -DPYTHON3_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3
    ]

    if Hardware::CPU.intel?
      args << "-DENABLE_AVX=OFF" << "-DENABLE_AVX2=OFF"
      args << "-DENABLE_SSE41=OFF" << "-DENABLE_SSE42=OFF" unless MacOS.version.requires_sse42?
    end

    mkdir "build" do
      os = "mac"
      on_linux do
        os = "linux"
      end
      system "cmake", "..", *args
      inreplace "modules/core/version_string.inc", "#{HOMEBREW_SHIMS_PATH}/#{os}/super/", ""
      system "make"
      system "make", "install"
      system "make", "clean"
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *args
      inreplace "modules/core/version_string.inc", "#{HOMEBREW_SHIMS_PATH}/#{os}/super/", ""
      system "make"
      lib.install Dir["lib/*.a"]
      lib.install Dir["3rdparty/**/*.a"]
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <opencv2/opencv.hpp>
      #include <iostream>
      int main() {
        std::cout << CV_VERSION << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}/opencv4",
                    "-o", "test"
    assert_equal `./test`.strip, version.to_s

    output = shell_output(Formula["python@3.9"].opt_bin/"python3 -c 'import cv2; print(cv2.__version__)'")
    assert_equal version.to_s, output.chomp
  end
end
