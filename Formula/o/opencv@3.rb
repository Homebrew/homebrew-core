class OpencvAT3 < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://github.com/opencv/opencv/archive/refs/tags/3.4.20.tar.gz"
  sha256 "b9eda448a08ba7b10bfd5bd45697056569ebdf7a02070947e1c1f3e8e69280cd"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sonoma:   "4cc2b2c1de1cb869d251fb5fb74538e2eab7d63b0588f84a70494126e5ff8500"
    sha256 arm64_ventura:  "e41c77e2b2bc44d9fd5c7a6999db47e7063f70ae4e878c31bd2f0cee49ed55fd"
    sha256 arm64_monterey: "5420a7536c02498251ce0bc2315d5d7d4ba66c207ac27b418e68ac4e59fde8e3"
    sha256 sonoma:         "e9da7e9b03a5bc2b782a263561a1e465538fb0ae6d53ee1903b03b23ca7bd1ba"
    sha256 ventura:        "4efcfe32624a7f94d1541d8f8939afc0979226e0e5b6ed5e79e647bf8f16ae54"
    sha256 monterey:       "513823481211ab8fb937f27b9ba23e1bcd8524a22f6283cb3fd51de6c1202997"
    sha256 x86_64_linux:   "76ab86b278b87ab1df04d85d7dc1af660aedadce4d380b553860fbd22afe2ce8"
  end

  keg_only :versioned_formula

  # see https://github.com/opencv/opencv/wiki/Branches#eol-branches
  disable! date: "2024-01-31", because: :unmaintained

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "ceres-solver"
  depends_on "eigen"
  depends_on "ffmpeg@4"
  depends_on "gflags"
  depends_on "glog"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "numpy"
  depends_on "openexr"
  depends_on "protobuf@21"
  depends_on "python@3.12"
  depends_on "tbb"
  depends_on "webp"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  resource "contrib" do
    url "https://github.com/opencv/opencv_contrib/archive/refs/tags/3.4.20.tar.gz"
    sha256 "b0bb3fa7ae4ac00926b83d4d95c6500c2f7af542f8ec78d0f01b2961a690d5dc"
  end

  def python3
    "python3.12"
  end

  def install
    resource("contrib").stage buildpath/"opencv_contrib"

    # Reset PYTHONPATH, workaround for https://github.com/Homebrew/homebrew-science/pull/4885
    ENV.delete("PYTHONPATH")

    # Remove bundled libraries to make sure formula dependencies are used
    libdirs = %w[ffmpeg libjasper libjpeg libjpeg-turbo libpng libtiff libwebp openexr protobuf tbb zlib]
    libdirs.each { |l| (buildpath/"3rdparty"/l).rmtree }

    args = std_cmake_args + %W[
      -DCMAKE_CXX_STANDARD=11
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DBUILD_JASPER=OFF
      -DBUILD_JPEG=OFF
      -DBUILD_OPENEXR=OFF
      -DBUILD_PERF_TESTS=OFF
      -DBUILD_PNG=OFF
      -DBUILD_PROTOBUF=OFF
      -DBUILD_TBB=OFF
      -DBUILD_TESTS=OFF
      -DBUILD_TIFF=OFF
      -DBUILD_WEBP=OFF
      -DBUILD_ZLIB=OFF
      -DBUILD_opencv_hdf=OFF
      -DBUILD_opencv_java=OFF
      -DBUILD_opencv_text=OFF
      -DOPENCV_ENABLE_NONFREE=ON
      -DOPENCV_EXTRA_MODULES_PATH=#{buildpath}/opencv_contrib/modules
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
      -DWITH_VTK=OFF
      -DBUILD_opencv_python2=OFF
      -DBUILD_opencv_python3=ON
      -DPYTHON3_EXECUTABLE=#{which(python3)}
    ]

    if Hardware::CPU.intel? && build.bottle?
      args << "-DENABLE_AVX=OFF" << "-DENABLE_AVX2=OFF"
      args << "-DENABLE_SSE41=OFF" << "-DENABLE_SSE42=OFF" if !OS.mac? || !MacOS.version.requires_sse42?
    end

    system "cmake", "-S", ".", "-B", "build_shared", *args
    inreplace "build_shared/modules/core/version_string.inc", "#{Superenv.shims_path}/", ""
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static", *args, "-DBUILD_SHARED_LIBS=OFF"
    inreplace "build_static/modules/core/version_string.inc", "#{Superenv.shims_path}/", ""
    system "cmake", "--build", "build_static"
    lib.install Dir["build_static/lib/*.a"]
    lib.install Dir["build_static/3rdparty/**/*.a"]
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
    assert_equal shell_output("./test").strip, version.to_s

    ENV["PYTHONPATH"] = prefix/Language::Python.site_packages(python3)
    output = shell_output("#{python3} -c 'import cv2; print(cv2.__version__)'")
    assert_equal version.to_s, output.chomp
  end
end
