class Opencv < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  url "https://github.com/opencv/opencv/archive/refs/tags/4.8.1.tar.gz"
  sha256 "62f650467a60a38794d681ae7e66e3e8cfba38f445e0bf87867e2f2cdc8be9d5"
  license "Apache-2.0"
  revision 4

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "62e12b3997a5b5cc4e6d759b61bc00b957897d60c78ce3e054da18c645ba2f4e"
    sha256 arm64_ventura:  "0854a41759b42eea39d864c3163c5cb98d7d9d03a9a04967afddb0d22cdfb253"
    sha256 arm64_monterey: "b9dd72019491840ba1b042903b77acae9038a2b24f044fd051594af73c62cd2e"
    sha256 sonoma:         "49e47e92b5fbece885a26b7951cb6bc2838c65532899019e8baa5bc25bb77df9"
    sha256 ventura:        "09fb4e92cb4accad87ff7f9fe58aa3489018e593f01b3ff5203ed63142d1f0f1"
    sha256 monterey:       "70591c94efd9c8a63dcdb42a30ea39610e5c06e65ad1799860d738aaba790c0e"
    sha256 x86_64_linux:   "059f42cc891983d4e315bcc5fb6a8e70d4c8defb335472797b25d13e2cdd289a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
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
  depends_on "openjdk"
  depends_on "openjpeg"
  depends_on "openvino"
  depends_on "protobuf"
  depends_on "python@3.12"
  depends_on "tbb"
  depends_on "vtk"
  depends_on "webp"

  uses_from_macos "zlib"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  resource "contrib" do
    url "https://github.com/opencv/opencv_contrib/archive/refs/tags/4.8.1.tar.gz"
    sha256 "0c082a0b29b3118f2a0a1856b403bb098643af7b994a0080f402a12159a99c6e"
  end

  # Fix static build with OpenVINO (https://github.com/opencv/opencv/pull/23963)
  # Remove patch when available in release.
  patch do
    url "https://github.com/opencv/opencv/commit/ef9d14f181ad8cca71443beaf3874de3197d4e47.patch?full_index=1"
    sha256 "efdf5534479af2e246c162215d5cbc2ae49e962ca58ccd9fef610fa40ee4a4ed"
  end

  def python3
    "python3.12"
  end

  def install
    resource("contrib").stage buildpath/"opencv_contrib"

    ENV["JAVA_HOME"] = Language::Java.java_home

    # Avoid Accelerate.framework
    ENV["OpenBLAS_HOME"] = Formula["openblas"].opt_prefix

    # Reset PYTHONPATH, workaround for https://github.com/Homebrew/homebrew-science/pull/4885
    ENV.delete("PYTHONPATH")

    # Remove bundled libraries to make sure formula dependencies are used
    libdirs = %w[ffmpeg libjasper libjpeg libjpeg-turbo libpng libtiff libwebp openexr openjpeg protobuf tbb zlib]
    libdirs.each { |l| (buildpath/"3rdparty"/l).rmtree }

    args = %W[
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
      -DBUILD_JAVA=ON
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
      -DWITH_OPENVINO=ON
      -DWITH_QT=OFF
      -DWITH_TBB=ON
      -DWITH_VTK=ON
      -DBUILD_opencv_python2=OFF
      -DBUILD_opencv_python3=ON
      -DPYTHON3_EXECUTABLE=#{which(python3)}
    ]

    args += [
      "-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON", # https://github.com/protocolbuffers/protobuf/issues/12292
      "-Dprotobuf_MODULE_COMPATIBLE=ON", # https://github.com/protocolbuffers/protobuf/issues/1931
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

    system "cmake", "-S", ".", "-B", "build_shared", *args, *std_cmake_args
    inreplace "build_shared/modules/core/version_string.inc", "#{Superenv.shims_path}/", ""
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static", *args, *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
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

    (testpath/"Test.java").write <<~EOS
      import org.opencv.core.Core;

      public class Test {
        public static void main(String[] args) {
          System.out.print(Core.VERSION);
        }
      }
    EOS

    output = shell_output("#{Formula["openjdk"].opt_bin}/java -cp #{share}/java/opencv#{version.major}/opencv-#{version.to_s.delete "."}.jar Test.java")
    assert_equal output.strip, version.to_s
  end
end
