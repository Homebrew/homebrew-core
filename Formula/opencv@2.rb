class OpencvAT2 < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  url "https://github.com/opencv/opencv/archive/2.4.13.5.tar.gz"
  sha256 "5fe6a78bebc62137a8bd1209f6b5e4f27b9d5892cc03cf4745cb78c832b15210"

  bottle do
    sha256 "7649a480c1a417585c63931e113069ac41458155dc62ba0f49f482479bef2e67" => :high_sierra
    sha256 "671bdafb37971ad9497f5924daecf8f9e0a7649c615cde04eb8cc278334c8d49" => :sierra
    sha256 "63bedafc181f8ab479787b05b769c85c183dce0359cdc50efd2ef8c90302c2d1" => :el_capitan
  end

  keg_only :versioned_formula

  option "without-python", "Build without python2 support"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "ffmpeg"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"
  depends_on "python" => :recommended if MacOS.version <= :snow_leopard
  depends_on "numpy" if build.with? "python"

  def install
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
      -DBUILD_opencv_java=OFF
      -DWITH_CUDA=OFF
      -DWITH_EIGEN=ON
      -DWITH_FFMPEG=ON
      -DWITH_GSTREAMER=OFF
      -DWITH_JASPER=OFF
      -DWITH_OPENEXR=ON
      -DWITH_OPENGL=ON
      -DWITH_TBB=OFF
      -DJPEG_INCLUDE_DIR=#{jpeg.opt_include}
      -DJPEG_LIBRARY=#{jpeg.opt_lib}/libjpeg.dylib
    ]

    args << "-DBUILD_opencv_python=" + (build.with?("python") ? "ON" : "OFF")

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
    assert_equal version.to_s, shell_output("./test").strip

    ENV["PYTHONPATH"] = lib/"python2.7/site-packages"
    assert_match version.to_s,
                 shell_output("python -c 'import cv2; print(cv2.__version__)'")
  end
end
