class Opencv < Formula
  desc "Open source computer vision library"
  homepage "http://opencv.org/"
  url "https://github.com/opencv/opencv/archive/2.4.13.2.tar.gz"
  sha256 "4b00c110e6c54943cbbb7cf0d35c5bc148133ab2095ee4aaa0ac0a4f67c58080"
  head "https://github.com/opencv/opencv.git", :branch => "2.4"

  option "with-java", "Build with Java support"
  option "with-tbb", "Enable parallel code in OpenCV using Intel TBB"
  option "without-numpy", "Use your own numpy instead of Homebrew's numpy"
  option "without-python", "Build without python support"

  option :cxx11

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on "numpy" => :recommended if build.with? "python"
  depends_on "jasper" => :optional
  depends_on :java => :optional
  depends_on :ant if build.with? "java"
  depends_on "tbb" => :optional

  # Can also depend on ffmpeg, but this pulls in a lot of extra stuff that
  # you don't need unless you're doing video analysis, and some of it isn't
  # in Homebrew anyway.
  depends_on "ffmpeg" => :optional

  def arg_switch(opt)
    (build.with? opt) ? "ON" : "OFF"
  end

  def install
    ENV.cxx11 if build.cxx11?
    jpeg = Formula["jpeg"]

    args = std_cmake_args + %W[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DBUILD_JASPER=OFF
      -DBUILD_JPEG=OFF
      -DBUILD_OPENEXR=OFF
      -DBUILD_PERF_TESTS=OFF
      -DBUILD_PNG=OFF
      -DBUILD_TESTS=OFF
      -DBUILD_TIFF=OFF
      -DBUILD_ZLIB=OFF
      -DJPEG_INCLUDE_DIR=#{jpeg.opt_include}
      -DJPEG_LIBRARY=#{jpeg.opt_lib}/libjpeg.dylib
      -DWITH_1394=OFF
      -DWITH_CUDA=OFF
      -DWITH_GSTREAMER=OFF
      -DWITH_QUICKTIME=OFF
      -DWITH_VTK=OFF
      -DWITH_EIGEN=ON
      -DWITH_OPENEXR=ON
      -DWITH_OPENGL=ON
      -DWITH_XIMEA=ON
    ]

    args << "-DBUILD_opencv_python=" + arg_switch("python")
    args << "-DBUILD_opencv_java=" + arg_switch("java")
    args << "-DWITH_FFMPEG=" + arg_switch("ffmpeg")
    args << "-DWITH_JASPER=" + arg_switch("jasper")
    args << "-DWITH_TBB=" + arg_switch("tbb")

    if build.with? "python"
      py_prefix = `python-config --prefix`.chomp
      py_lib = "#{py_prefix}/lib"
      args << "-DPYTHON_LIBRARY=#{py_lib}/libpython2.7.dylib"
      args << "-DPYTHON_INCLUDE_DIR=#{py_prefix}/include/python2.7"

      # Make sure find_program locates system Python
      # https://github.com/Homebrew/homebrew-science/issues/2302
      args << "-DCMAKE_PREFIX_PATH=#{py_prefix}"
    end

    if ENV.compiler == :clang && !build.bottle?
      args << "-DENABLE_SSSE3=ON" if Hardware::CPU.ssse3?
      args << "-DENABLE_SSE41=ON" if Hardware::CPU.sse4?
      args << "-DENABLE_SSE42=ON" if Hardware::CPU.sse4_2?
      args << "-DENABLE_AVX=ON" if Hardware::CPU.avx?
    end

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
    assert_equal version.to_s, shell_output("./test").strip
    assert_match version.to_s, shell_output("python -c 'import cv2; print(cv2.__version__)'")
  end
end
