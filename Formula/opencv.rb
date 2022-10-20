class Opencv < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  url "https://github.com/opencv/opencv/archive/refs/tags/4.6.0.tar.gz"
  sha256 "1ec1cba65f9f20fe5a41fda1586e01c70ea0c9a6d7b67c9e13edf0cfe2239277"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "43d0fa746d4db8fb75c47f71dd519d04c0b46db1fb28cec002b295b96972adfa"
    sha256 arm64_big_sur:  "2bbfa4767c6802cbe2efff58bf3738e9a4e4ebc3aa3bc79505627130a0896ba8"
    sha256 monterey:       "62878a3c791996285f5bdff682b7fc55504ca612670f6cb9b256de8326fee1da"
    sha256 big_sur:        "180902fac413cf9e5b12eb3546c33912b6c8c9ecbf97777a017063a969bb8f3d"
    sha256 catalina:       "883865a2853fb27173d02fc1bb2bbe64f65a139397632bc3e7c8f1917f983911"
    sha256 x86_64_linux:   "59b917c12d31880b30da1173d70f479f2f93a3b1bbb882429e2a8ee59585b267"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ceres-solver"
  depends_on "eigen"
  depends_on "ffmpeg"
  depends_on "glog"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "numpy"
  depends_on "openblas"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "protobuf"
  depends_on "python@3.10"
  depends_on "tbb"
  depends_on "vtk"
  depends_on "webp"

  uses_from_macos "zlib"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  resource "contrib" do
    url "https://github.com/opencv/opencv_contrib/archive/refs/tags/4.6.0.tar.gz"
    sha256 "1777d5fd2b59029cf537e5fd6f8aa68d707075822f90bde683fcde086f85f7a7"

    # Fix build error: cannot initialize a parameter of type 'ceres::LocalParameterization *'
    # Remove in the next release.
    patch do
      url "https://github.com/opencv/opencv_contrib/commit/4c93cc9925ece6c4a38cf8b869c8217d15104fe5.patch?full_index=1"
      sha256 "9761c48d1c6f19fa0a2bf5a55cf7a0501a1e85fe595006ec5bd1929d9602f702"
    end
  end

  # Fix build error: use of undeclared identifier 'CODEC_ID_H264'; did you mean 'AV_CODEC_ID_H264'
  # Using commit from related PR for 3.4 branch: https://github.com/opencv/opencv/pull/22357
  # Remove when fix is in 4.x branch and available in a release.
  patch do
    url "https://github.com/opencv/opencv/commit/496eed950f6d0e7fd92619d47e3cec8f06e96ace.patch?full_index=1"
    sha256 "f9a5dac14d54b699383328a2d28b2d86f7274db8a603974ca5e9076d77490d49"
  end

  def python3
    "python3.10"
  end

  def install
    resource("contrib").stage buildpath/"opencv_contrib"

    # Avoid Accelerate.framework
    ENV["OpenBLAS_HOME"] = Formula["openblas"].opt_prefix

    # Reset PYTHONPATH, workaround for https://github.com/Homebrew/homebrew-science/pull/4885
    ENV.delete("PYTHONPATH")

    # Remove bundled libraries to make sure formula dependencies are used
    libdirs = %w[ffmpeg libjasper libjpeg libjpeg-turbo libpng libtiff libwebp openexr openjpeg protobuf tbb zlib]
    libdirs.each { |l| (buildpath/"3rdparty"/l).rmtree }

    args = std_cmake_args + %W[
      -DCMAKE_CXX_STANDARD=11
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DBUILD_JASPER=OFF
      -DBUILD_JPEG=OFF
      -DBUILD_OPENEXR=OFF
      -DBUILD_OPENJPEG=OFF
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
      -DPYTHON3_EXECUTABLE=#{which(python3)}
    ]

    # Disable precompiled headers and force opencv to use brewed libraries on Linux
    if OS.linux?
      args += %W[
        -DENABLE_PRECOMPILED_HEADERS=OFF
        -DJPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_lib}/libjpeg.so
        -DOpenBLAS_LIB=#{Formula["openblas"].opt_lib}/libopenblas.so
        -DOPENEXR_ILMIMF_LIBRARY=#{Formula["openexr"].opt_lib}/libIlmImf.so
        -DOPENEXR_ILMTHREAD_LIBRARY=#{Formula["openexr"].opt_lib}/libIlmThread.so
        -DPNG_LIBRARY=#{Formula["libpng"].opt_lib}/libpng.so
        -DPROTOBUF_LIBRARY=#{Formula["protobuf"].opt_lib}/libprotobuf.so
        -DTIFF_LIBRARY=#{Formula["libtiff"].opt_lib}/libtiff.so
        -DWITH_V4L=OFF
        -DZLIB_LIBRARY=#{Formula["zlib"].opt_lib}/libz.so
      ]
    end

    # Ref: https://github.com/opencv/opencv/wiki/CPU-optimizations-build-options
    ENV.runtime_cpu_detection
    if Hardware::CPU.intel? && build.bottle?
      cpu_baseline = MacOS.version.requires_sse42? ? "SSE4_2" : "SSSE3"
      args += %W[-DCPU_BASELINE=#{cpu_baseline} -DCPU_BASELINE_REQUIRE=#{cpu_baseline}]
    end

    system "cmake", "-S", ".", "-B", "build_shared", *args
    inreplace "build_shared/modules/core/version_string.inc", "#{Superenv.shims_path}/", ""
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static", *args, "-DBUILD_SHARED_LIBS=OFF"
    inreplace "build_static/modules/core/version_string.inc", "#{Superenv.shims_path}/", ""
    system "cmake", "--build", "build_static"
    lib.install buildpath.glob("build_static/{lib,3rdparty/**}/*.a")

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
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}/opencv4", "-o", "test"
    assert_equal shell_output("./test").strip, version.to_s

    output = shell_output("#{python3} -c 'import cv2; print(cv2.__version__)'")
    assert_equal version.to_s, output.chomp
  end
end
