class OpencvAT2 < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  url "https://github.com/opencv/opencv/archive/2.4.13.7.tar.gz"
  sha256 "192d903588ae2cdceab3d7dc5a5636b023132c8369f184ca89ccec0312ae33d0"
  license "BSD-3-Clause"
  revision 12

  bottle do
    sha256 cellar: :any, arm64_monterey: "83c5326c95de73c14aa11909ade85f8f78684f5386d6f134201976eafb63e497"
    sha256               arm64_big_sur:  "80480cb6ead5fdcdb15ff6a15ce76ab6650da02b1d41f29e719afaf311e9cc4c"
    sha256 cellar: :any, monterey:       "1a2972e1851f1c02e5259820b798688345525bd906f0840cf6761ec0f4882015"
    sha256               big_sur:        "ccca6d5ab6c409984409b978bb1f44d753cb973e0d11dd8721fdda7dffa9713c"
    sha256               catalina:       "f3d3e73afb743e429cbcfe84c44ef461eedb85fe040a3e2da15979ee3ddabfd3"
    sha256               mojave:         "04149e97504dff8e9d76258126f403e24dabe31245620091dbc452af6722dc2a"
  end

  keg_only :versioned_formula

  # https://www.slideshare.net/EugeneKhvedchenya/opencv-30-latest-news-and-the-roadmap
  disable! date: "2022-07-31", because: :unsupported

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "ffmpeg"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on :macos # Due to Python 2
  depends_on "numpy@1.16"
  depends_on "openexr"

  def install
    ENV.cxx11
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
      -DBUILD_opencv_python=ON
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
      -DENABLE_SSSE3=ON
    ]

    py_prefix = `python-config --prefix`.chomp
    py_lib = "#{py_prefix}/lib"
    args << "-DPYTHON_LIBRARY=#{py_lib}/libpython2.7.dylib"
    args << "-DPYTHON_INCLUDE_DIR=#{py_prefix}/include/python2.7"

    # Make sure find_program locates system Python
    # https://github.com/Homebrew/homebrew-science/issues/2302
    args << "-DCMAKE_PREFIX_PATH=#{py_prefix}"

    args << "-DENABLE_SSE41=ON" << "-DENABLE_SSE42=ON" \
      if Hardware::CPU.intel? && MacOS.version.requires_sse42?

    mkdir "build" do
      system "cmake", "..", *args
      inreplace "modules/core/version_string.inc", Superenv.shims_path, ""
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
    output = shell_output("python2.7 -c 'import cv2; print(cv2.__version__)'")
    assert_match version.to_s, output
  end
end
