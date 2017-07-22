class Opencv3 < Formula
  desc "Open source computer vision library, version 3"
  homepage "http://opencv.org/"

  stable do
    url "https://github.com/opencv/opencv/archive/3.2.0.tar.gz"
    sha256 "b9d62dfffb8130d59d587627703d5f3e6252dce4a94c1955784998da7a39dd35"

    resource "contrib" do
      url "https://github.com/opencv/opencv_contrib/archive/3.2.0.tar.gz"
      sha256 "1e2bb6c9a41c602904cc7df3f8fb8f98363a88ea564f2a087240483426bf8cbe"
    end
  end

  head do
    url "https://github.com/opencv/opencv.git"

    resource "contrib" do
      url "https://github.com/opencv/opencv_contrib.git"
    end
  end

  keg_only :versioned_formula

  option "with-java", "Build with Java support"
  option "with-qt", "Build the Qt backend to HighGUI"
  option "with-tbb", "Enable parallel code in OpenCV using Intel TBB"
  option "without-numpy", "Use a numpy you've installed yourself instead of a Homebrew-packaged numpy"
  option "without-python", "Build without Python support"

  option :cxx11

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"
  depends_on "ffmpeg" => :optional
  depends_on "gstreamer" => :optional
  depends_on "gst-plugins-good" if build.with? "gstreamer"
  depends_on :java => :optional
  depends_on :ant => :build if build.with? "java"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on :python3 => :optional
  depends_on "qt" => :optional
  depends_on "tbb" => :optional

  with_python = build.with?("python") || build.with?("python3")
  pythons = build.with?("python3") ? ["with-python3"] : []
  depends_on "numpy" => [:recommended] + pythons if with_python

  # Dependencies use fortran, which leads to spurious messages about gcc
  cxxstdlib_check :skip

  resource "icv" do
    url "https://raw.githubusercontent.com/opencv/opencv_3rdparty/81a676001ca8075ada498583e4166079e5744668/ippicv/ippicv_macosx_20151201.tgz", :using => :nounzip
    sha256 "8a067e3e026195ea3ee5cda836f25231abb95b82b7aa25f0d585dc27b06c3630"
  end

  def arg_switch(opt)
    build.with?(opt) ? "ON" : "OFF"
  end

  def install
    ENV.cxx11 if build.cxx11?

    args = std_cmake_args + %W[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DBUILD_JASPER=OFF
      -DBUILD_JPEG=OFF
      -DBUILD_OPENEXR=OFF
      -DBUILD_PERF_TESTS=OFF
      -DBUILD_PNG=ON
      -DBUILD_TESTS=OFF
      -DBUILD_TIFF=ON
      -DBUILD_ZLIB=OFF
      -DINSTALL_C_EXAMPLES=ON
      -DINSTALL_PYTHON_EXAMPLES=ON
      -DWITH_1394=OFF
      -DWITH_CUDA=OFF
      -DWITH_EIGEN=ON
      -DWITH_GPHOTO2=OFF
      -DWITH_JASPER=OFF
      -DWITH_OPENEXR=ON
      -DWITH_OPENGL=ON
      -DWITH_QUICKTIME=OFF
      -DWITH_VTK=OFF
      -DJPEG_INCLUDE_DIR=#{Formula["jpeg"].opt_include}
      -DJPEG_LIBRARY=#{Formula["jpeg"].opt_lib}/libjpeg.dylib
      -DOPENCV_EXTRA_MODULES_PATH=#{buildpath}/opencv_contrib/modules
      -DOPENCV_ENABLE_NONFREE=ON
    ]

    args << "-DBUILD_opencv_java=" + arg_switch("java")
    args << "-DBUILD_opencv_python2=" + arg_switch("python")
    args << "-DBUILD_opencv_python3=" + arg_switch("python3")
    args << "-DWITH_FFMPEG=" + arg_switch("ffmpeg")
    args << "-DWITH_GSTREAMER=" + arg_switch("gstreamer")
    args << "-DWITH_QT=" + arg_switch("qt")
    args << "-DWITH_TBB=" + arg_switch("tbb")

    if build.with?("python3") && build.with?("python")
      odie "opencv3: Does not support building both Python 2 and 3 wrappers"
    end

    if build.with? "python"
      py_prefix = `python-config --prefix`.chomp
      py_lib = "#{py_prefix}/lib"
      args << "-DPYTHON2_EXECUTABLE=#{which "python"}"
      args << "-DPYTHON2_LIBRARY=#{py_lib}/libpython2.7.dylib"
      args << "-DPYTHON2_INCLUDE_DIR=#{py_prefix}/include/python2.7"
    end

    if build.with? "python3"
      # Reset PYTHONPATH, workaround for https://github.com/Homebrew/homebrew-science/pull/4885
      ENV["PYTHONPATH"] = ""
      py3_config = `python3-config --configdir`.chomp
      py3_include = `python3 -c "import distutils.sysconfig as s; print(s.get_python_inc())"`.chomp
      py3_version = Language::Python.major_minor_version "python3"
      args << "-DPYTHON3_EXECUTABLE=#{which "python3"}"
      args << "-DPYTHON3_LIBRARY=#{py3_config}/libpython#{py3_version}.dylib"
      args << "-DPYTHON3_INCLUDE_DIR=#{py3_include}"
    end

    if ENV.compiler == :clang && !build.bottle?
      args << "-DENABLE_SSSE3=ON" if Hardware::CPU.ssse3?
      args << "-DENABLE_SSE41=ON" if Hardware::CPU.sse4?
      args << "-DENABLE_SSE42=ON" if Hardware::CPU.sse4_2?
      args << "-DENABLE_AVX=ON" if Hardware::CPU.avx?
      args << "-DENABLE_AVX2=ON" if Hardware::CPU.avx2?
    end

    inreplace buildpath/"3rdparty/ippicv/downloader.cmake",
      "${OPENCV_ICV_PLATFORM}-${OPENCV_ICV_PACKAGE_HASH}",
      "${OPENCV_ICV_PLATFORM}"
    resource("icv").stage buildpath/"3rdparty/ippicv/downloads/#{platform}"

    resource("contrib").stage buildpath/"opencv_contrib"

    mkdir "macbuild" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <opencv/cv.h>
      #include <iostream>
      int main()
      {
        std::cout << CV_VERSION << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal `./test`.strip, version.to_s

    ENV["PYTHONPATH"] = lib/"python2.7/site-packages"
    assert_match version.to_s, shell_output("python -c 'import cv2; print(cv2.__version__)'")
  end
end
