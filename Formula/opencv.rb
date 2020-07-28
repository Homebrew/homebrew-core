class Opencv < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  url "https://github.com/opencv/opencv/archive/4.4.0.tar.gz"
  sha256 "bb95acd849e458be7f7024d17968568d1ccd2f0681d47fd60d34ffb4b8c52563"
  license "BSD-3-Clause"

  bottle do
    sha256 "7524401992a83c2a5ad655a27a153b027b9fc1a72bdc564842a4b9e32eb27201" => :catalina
    sha256 "f229e1f1cfdd547b38addb5ceed3e43277a823dd06860116a1059a1209623407" => :mojave
    sha256 "7353af965d428d1e2a22f3c641b3a2bd25740d5f6476e88ba8fc9564029926b0" => :high_sierra
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
  depends_on "vtk"
  depends_on "webp"

  resource "contrib" do
    url "https://github.com/opencv/opencv_contrib/archive/4.4.0.tar.gz"
    sha256 "a69772f553b32427e09ffbfd0c8d5e5e47f7dab8b3ffc02851ffd7f912b76840"
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
      inreplace "modules/core/version_string.inc", "#{HOMEBREW_SHIMS_PATH}/mac/super/", ""
      system "make"
      system "make", "install"
      system "make", "clean"
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *args
      inreplace "modules/core/version_string.inc", "#{HOMEBREW_SHIMS_PATH}/mac/super/", ""
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
