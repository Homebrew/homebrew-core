class OpencvAT3 < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  url "https://github.com/opencv/opencv/archive/3.4.15.tar.gz"
  sha256 "b1e8470b18e9e793bf70b4ae051bbc9bf81fa45f8cbfee1e6c88858c90be8ff7"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "30f24b7ae1e2d3f63072e0abd4cd8c110063766abee4ea59eb885eb9a3137e7f"
    sha256 big_sur:       "d7430cf4a9378666322b6d5fae8c9804314e7e91e1ceff20739fd133d6968c2b"
    sha256 catalina:      "36a4597c6d285a881ae976f26b31293242865a294d67db9ae91e1c75096bc81d"
    sha256 mojave:        "73d93954772b452010c15441e87ab429cfaed0185478463eb7d601e0fbb521a2"
    sha256 x86_64_linux:  "eeda9a7dad6d03a9070df0704c47bdbb8aeffd85ff750a13f9c4b20f168f8200"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ceres-solver"
  depends_on "eigen"
  depends_on "ffmpeg"
  depends_on "gflags"
  depends_on "glog"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "numpy"
  depends_on "openexr"
  depends_on "python@3.9"
  depends_on "tbb"

  resource "contrib" do
    url "https://github.com/opencv/opencv_contrib/archive/3.4.15.tar.gz"
    sha256 "5004024f2e92e520d324f235dc30a80878fd501fb03ca1f98ca3cbd53d27b6fb"
  end

  # tbb 2021 support. Backport of
  # https://github.com/opencv/opencv/pull/19384
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/ec823c01d3275b13b527e4860ae542fac11da24c/opencv%403/tbb2021.patch"
    sha256 "a125f962ea07f0656869cbd97433f0e465013effc13c97a414752e0d25ed9a7d"
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
      -DBUILD_opencv_hdf=OFF
      -DBUILD_opencv_java=OFF
      -DBUILD_opencv_text=OFF
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
      -DBUILD_opencv_python2=OFF
      -DBUILD_opencv_python3=ON
      -DPYTHON3_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3
    ]

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

    py3_version = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV["PYTHONPATH"] = lib/"python#{py3_version}/site-packages"
    output = shell_output(Formula["python@3.9"].opt_bin/"python3 -c 'import cv2; print(cv2.__version__)'")
    assert_equal version.to_s, output.chomp
  end
end
