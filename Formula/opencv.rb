class Opencv < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  url "https://github.com/opencv/opencv/archive/4.3.0.tar.gz"
  sha256 "68bc40cbf47fdb8ee73dfaf0d9c6494cd095cf6294d99de445ab64cf853d278a"

  bottle do
    sha256 "3095eb5401ccfa7b82cb981001e2a221c5256466e6c93d38a6a43ac40e7580f8" => :catalina
    sha256 "abd96714041aba19f5e258b150f62ff38455f7bc7e1a480002494cda035b839f" => :mojave
    sha256 "02435b9e0fa99d0d0841951a5c89617cadf1381dca51ee533c0e7f6b82d4ab34" => :high_sierra
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
  depends_on "python@3.8"
  depends_on "tbb"
  depends_on "webp"

  resource "contrib" do
    url "https://github.com/opencv/opencv_contrib/archive/4.3.0.tar.gz"
    sha256 "acb8e89c9e7d1174e63e40532125b60d248b00e517255a98a419d415228c6a55"
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
      -DWITH_VTK=OFF
      -DBUILD_opencv_python2=OFF
      -DBUILD_opencv_python3=ON
      -DPYTHON3_EXECUTABLE=#{Formula["python@3.8"].opt_bin}/python3
    ]

    # The compiler on older Mac OS cannot build some OpenCV files using AVX2
    # extensions, failing with errors such as
    # "error: use of undeclared identifier '_mm256_cvtps_ph'"
    # Work around this by not trying to build AVX2 code.
    args << "-DCPU_DISPATCH=SSE4_1,SSE4_2,AVX" if MacOS.version <= :yosemite

    args << "-DENABLE_AVX=OFF" << "-DENABLE_AVX2=OFF"
    args << "-DENABLE_SSE41=OFF" << "-DENABLE_SSE42=OFF" unless MacOS.version.requires_sse42?

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
      system "make", "clean"
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *args
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

    output = shell_output(Formula["python@3.8"].opt_bin/"python3 -c 'import cv2; print(cv2.__version__)'")
    assert_equal version.to_s, output.chomp
  end
end
