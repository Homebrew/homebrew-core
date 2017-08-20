class Opencv < Formula
  desc "Open source computer vision library"
  homepage "http://opencv.org/"
  url "https://github.com/opencv/opencv/archive/3.3.0.tar.gz"
  sha256 "95029eb5578af3b20b8c7f8f6f59db1b827c2d5aaaa74b6becb1de647cbdda5a"
  revision 2

  option "without-python", "Build without python2 support"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "ffmpeg"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on :python3 => :recommended
  depends_on "numpy" if build.with?("python") || build.with?("python3")

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
    ]

    args << "-DBUILD_opencv_python2=" + (build.with?("python") ? "ON" : "OFF")
    args << "-DBUILD_opencv_python3=" + (build.with?("python3") ? "ON" : "OFF")

    if build.with? "python"
      py_prefix = `python-config --prefix`.chomp
      py_lib = "#{py_prefix}/lib"
      args << "-DPYTHON2_EXECUTABLE=#{which "python"}"
      args << "-DPYTHON2_LIBRARY=#{py_lib}/libpython2.7.dylib"
      args << "-DPYTHON2_INCLUDE_DIR=#{py_prefix}/include/python2.7"
    end

    if build.with? "python3"
      py3_config = `python3-config --configdir`.chomp
      py3_include = `python3 -c "import distutils.sysconfig as s; print(s.get_python_inc())"`.chomp
      py3_version = Language::Python.major_minor_version "python3"
      args << "-DPYTHON3_EXECUTABLE=#{which "python3"}"
      args << "-DPYTHON3_LIBRARY=#{py3_config}/libpython#{py3_version}.dylib"
      args << "-DPYTHON3_INCLUDE_DIR=#{py3_include}"
    end

    if build.bottle?
      args += %w[-DENABLE_SSSE3=OFF -DENABLE_SSE41=OFF -DENABLE_SSE42=OFF
                 -DENABLE_AVX=OFF -DENABLE_AVX2=OFF]
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

    Language::Python.each_python(build) do |python, _version|
      assert_match version.to_s,
                   shell_output("#{python} -c 'import cv2; print(cv2.__version__)'")
    end
  end
end
