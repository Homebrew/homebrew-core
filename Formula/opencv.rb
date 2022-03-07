class Opencv < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  url "https://github.com/opencv/opencv/archive/4.5.5.tar.gz"
  sha256 "a1cfdcf6619387ca9e232687504da996aaa9f7b5689986b8331ec02cb61d28ad"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_monterey: "c30513f997a7b463842be5723dc3524b403ae2e8851c4d6572c3554a9f2ac0b9"
    sha256                               arm64_big_sur:  "3340b75c1daa8c1fc969d40b68b39437b4061d36f54db11c8f566e420e890328"
    sha256                               monterey:       "b7034490e2db15c8c73efc32550e9ba9e759787e8bf5b30c355ea6c47540579d"
    sha256                               big_sur:        "5ab8654c831a1ad5225dabed141ee4a0f6d945c70a0cec677e4ab320d33f0fa1"
    sha256                               catalina:       "2df7d2874b1669736a0b89fabdc35b3bea0a0572e1cb3eee5fe7cd8a95459ad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0dbcd7860f347972dcedcd46ed2f3d40568aa10b94bffe90c31abc4a50064b2"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ceres-solver"
  depends_on "eigen"
  depends_on "ffmpeg@4"
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

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  resource "contrib" do
    url "https://github.com/opencv/opencv_contrib/archive/4.5.5.tar.gz"
    sha256 "a97c2eaecf7a23c6dbd119a609c6d7fae903e5f9ff5f1fe678933e01c67a6c11"
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
