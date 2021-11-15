class Opencv < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  url "https://github.com/opencv/opencv/archive/4.5.3.tar.gz"
  sha256 "77f616ae4bea416674d8c373984b20c8bd55e7db887fd38c6df73463a0647bab"
  license "Apache-2.0"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "362e1f291f9095f7344136e76a329cc9111a87c6218d3a6216f53e8e4f5749fa"
    sha256 big_sur:       "4e65f1661e82f31dd693fcc6f39c44acab6eec4b5cc08a75666136d6c30e9b16"
    sha256 catalina:      "b166348e4032734e850d85818d9d047d57f0742778118756fbe325df54a9b179"
    sha256 x86_64_linux:  "ca371a5ceb6ec0ed96a9d0332dd44e40172dc3e33890c089a8a7b15830a06542"
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

  uses_from_macos "zlib"

  resource "contrib" do
    url "https://github.com/opencv/opencv_contrib/archive/4.5.3.tar.gz"
    sha256 "73da052fd10e73aaba2560eaff10cc5177e2dcc58b27f8aedf7c649e24c233bc"
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

    # Disable precompiled headers and force opencv to use brewed libraries on Linux
    if OS.linux?
      args << "-DENABLE_PRECOMPILED_HEADERS=OFF"
      args << "-DJPEG_LIBRARY=#{Formula["libjpeg"].opt_lib}/libjpeg.so"
      args << "-DOpenBLAS_LIB=#{Formula["openblas"].opt_lib}/libopenblas.so"
      args << "-DOPENEXR_ILMIMF_LIBRARY=#{Formula["openexr"].opt_lib}/libIlmImf.so"
      args << "-DOPENEXR_ILMTHREAD_LIBRARY=#{Formula["openexr"].opt_lib}/libIlmThread.so"
      args << "-DPNG_LIBRARY=#{Formula["libpng"].opt_lib}/libpng.so"
      args << "-DPROTOBUF_LIBRARY=#{Formula["protobuf"].opt_lib}/libprotobuf.so"
      args << "-DTIFF_LIBRARY=#{Formula["libtiff"].opt_lib}/libtiff.so"
      args << "-DWITH_V4L=OFF"
      args << "-DZLIB_LIBRARY=#{Formula["zlib"].opt_lib}/libz.so"
    end

    if Hardware::CPU.intel?
      args << "-DENABLE_AVX=OFF" << "-DENABLE_AVX2=OFF"
      args << "-DENABLE_SSE41=OFF" << "-DENABLE_SSE42=OFF" unless MacOS.version.requires_sse42?
    end

    mkdir "build" do
      system "cmake", "..", *args
      inreplace "modules/core/version_string.inc", Superenv.shims_path, ""

      system "make"
      system "make", "install"

      system "make", "clean"
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *args
      inreplace "modules/core/version_string.inc", Superenv.shims_path, ""

      system "make"
      lib.install Dir["lib/*.a"]
      lib.install Dir["3rdparty/**/*.a"]
    end

    # Prevent dependents from using fragile Cellar paths
    inreplace lib/"pkgconfig/opencv#{version.major}.pc", prefix, opt_prefix
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
