class Opencv < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  revision 1

  stable do
    url "https://github.com/opencv/opencv/archive/3.3.1.tar.gz"
    sha256 "5dca3bb0d661af311e25a72b04a7e4c22c47c1aa86eb73e70063cd378a2aa6ee"

    # Upstream commit 8 Nov 2017 "cmake: fix pkg-config generation for MacOSX"
    patch do
      url "https://github.com/opencv/opencv/commit/a0e1def83bd.patch?full_index=1"
      sha256 "dbefbf198877320ee744bebc23b621f21484d0689e8218d8c1a661bc5c850975"
    end
  end

  bottle do
    sha256 "c857504e05f1150938a618c101a38f52761d874ef477d71f319dd22b530467a1" => :high_sierra
    sha256 "5a09d9bc84475db0026df47363f983c9104610ceece82270bdf60730b546e12b" => :sierra
    sha256 "745cdcae976045ee39b0f6912446a879ecc63b2d3d50898df2457745ebef2dc0" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "ffmpeg"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"
  depends_on :python
  depends_on :python3
  depends_on "numpy"
  depends_on "tbb"

  needs :cxx11

  resource "contrib" do
    url "https://github.com/opencv/opencv_contrib/archive/3.3.1.tar.gz"
    sha256 "6f3ce148dc6e147496f0dbec1c99e917e13bf138f5a8ccfc3765f5c2372bd331"
  end

  def install
    ENV.cxx11

    resource("contrib").stage buildpath/"opencv_contrib"

    # Reset PYTHONPATH, workaround for https://github.com/Homebrew/homebrew-science/pull/4885
    ENV.delete("PYTHONPATH")

    py_prefix = `python-config --prefix`.chomp
    py_lib = "#{py_prefix}/lib"

    py3_config = `python3-config --configdir`.chomp
    py3_include = `python3 -c "import distutils.sysconfig as s; print(s.get_python_inc())"`.chomp
    py3_version = Language::Python.major_minor_version "python3"

    args = std_cmake_args + %W[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DBUILD_JASPER=OFF
      -DBUILD_JPEG=ON
      -DBUILD_OPENEXR=OFF
      -DBUILD_PERF_TESTS=OFF
      -DBUILD_PNG=OFF
      -DBUILD_TESTS=OFF
      -DBUILD_TIFF=OFF
      -DBUILD_ZLIB=OFF
      -DBUILD_opencv_java=OFF
      -DOPENCV_ENABLE_NONFREE=ON
      -DOPENCV_EXTRA_MODULES_PATH=#{buildpath}/opencv_contrib/modules
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
      -DBUILD_opencv_python2=ON
      -DBUILD_opencv_python3=ON
      -DPYTHON2_EXECUTABLE=#{which "python"}
      -DPYTHON2_LIBRARY=#{py_lib}/libpython2.7.dylib
      -DPYTHON2_INCLUDE_DIR=#{py_prefix}/include/python2.7
      -DPYTHON3_EXECUTABLE=#{which "python3"}
      -DPYTHON3_LIBRARY=#{py3_config}/libpython#{py3_version}.dylib
      -DPYTHON3_INCLUDE_DIR=#{py3_include}
    ]

    if build.bottle?
      args += %w[-DENABLE_SSE41=OFF -DENABLE_SSE42=OFF -DENABLE_AVX=OFF
                 -DENABLE_AVX2=OFF]
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <opencv/cv.h>
      #include <iostream>
      int main() {
        std::cout << CV_VERSION << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal `./test`.strip, version.to_s

    ["python", "python3"].each do |python|
      output = shell_output("#{python} -c 'import cv2; print(cv2.__version__)'")
      assert_equal version.to_s, output.chomp
    end
  end
end
