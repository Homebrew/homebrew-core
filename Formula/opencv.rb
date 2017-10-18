class Opencv < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  url "https://github.com/opencv/opencv/archive/3.3.0.tar.gz"
  sha256 "8bb312b9d9fd17336dc1f8b3ac82f021ca50e2034afc866098866176d985adc6"
  revision 3

  bottle do
    sha256 "386ac2caf18b558237cf8a8a510fce0c56213259ce18e8bcf418513829e790fe" => :high_sierra
    sha256 "cf9f5f528cb2217a4fde2c635ce90d07b51e01564d7c66fc4413c41e22b17572" => :sierra
    sha256 "bd88772952a81606b7ff43e7d3874213680d4d190c319360f3da603b76f1cfb3" => :el_capitan
    sha256 "6073b44f5b601de364147a9b6b3ee784c6070303582cf3db9a513ce8a1796a0c" => :yosemite
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

  needs :cxx11

  resource "contrib" do
    url "https://github.com/opencv/opencv_contrib/archive/3.3.0.tar.gz"
    sha256 "e94acf39cd4854c3ef905e06516e5f74f26dddfa6477af89558fb40a57aeb444"
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
      -DWITH_TBB=OFF
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
    (testpath/"test.cpp").write <<-EOS.undent
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
