class OpencvAT3 < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  url "https://github.com/opencv/opencv/archive/3.4.16.tar.gz"
  sha256 "5e37b791b2fe42ed39b52d9955920b951ee42d5da95f79fbc9765a08ef733399"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256                               arm64_monterey: "c17d7f6cfef90d973d047faf3f6b73c1bd624834870f4dfd9a17f4aef06aa815"
    sha256                               arm64_big_sur:  "41aaf47fe8cf33d7908ac80534311345c16397e1fc39112e2e94533e20fc4fc9"
    sha256                               monterey:       "c866cb72bbb08a3f9d6b4db8d954212d0e8cedab7d98c767b29eb7d6a5e741c3"
    sha256                               big_sur:        "47da8b20aa0bfc6575f1e517be809277b34ecfd4e29e3587ea1065cd46203aff"
    sha256                               catalina:       "0cbda7587cde467f3ed7eccd6351b39d4a13a66a546d66ec12dffc27f3af660d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3278891223ac2981352a3a262a9aca9e019bdc54141f88cbd51619a914717404"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ceres-solver"
  depends_on "eigen"
  depends_on "ffmpeg@4"
  depends_on "gflags"
  depends_on "glog"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "numpy"
  depends_on "openexr"
  depends_on "python@3.9"
  depends_on "tbb"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  resource "contrib" do
    url "https://github.com/opencv/opencv_contrib/archive/3.4.16.tar.gz"
    sha256 "92b4f6ab8107e9de387bafc3c7658263e5c6be68554d6086b37a2cb168e332c5"
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
