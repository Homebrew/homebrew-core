class Opencv < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  license "Apache-2.0"
  revision 2
  compatibility_version 2

  stable do
    url "https://github.com/opencv/opencv/archive/refs/tags/5.0.0.tar.gz"
    sha256 "b0528f5a1d379d59d4701cb28c36e22214cc51cf64594e5b56f2d3e6c0233095"

    resource "contrib" do
      url "https://github.com/opencv/opencv_contrib/archive/refs/tags/5.0.0.tar.gz"
      sha256 "c58f6344170c39abf187c56f3843b59cab1fd3e89cf19ba2ce25dc061659b27f"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "6a9b2837e1f249ba816b2955870dddb74e1d760b45e1fd1296aabbbd8c196883"
    sha256 arm64_sequoia: "7a5359b5aebd45d96aaac23696e450b153c48831d58fcd258ec8827150e900d2"
    sha256 arm64_sonoma:  "933accc85d4e41a76598f43e6a20f782941879817d60cf54e3a2f1a178933ac7"
    sha256 sonoma:        "5d37c2c6985a088c625220ff2a0744e87b59c07bb3dc8b09e4eb5fc028ef9286"
    sha256 arm64_linux:   "239c50e9850b3dc6375e293c82fd69d80d6d8aaf0e8f01dac1c38db49ddf094c"
    sha256 x86_64_linux:  "4331e0997e5c9b814539e3c129423073dd8523bbef57950540157061167b609c"
  end

  head do
    url "https://github.com/opencv/opencv.git", branch: "5.x"

    resource "contrib" do
      url "https://github.com/opencv/opencv_contrib.git", branch: "5.x"
    end
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "abseil"
  depends_on "ceres-solver"
  depends_on "eigen"
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "gflags"
  depends_on "glog"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "jsoncpp"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "numpy"
  depends_on "openblas"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "openvino"
  depends_on "protobuf"
  depends_on "python@3.14"
  depends_on "tbb"
  depends_on "tesseract"
  depends_on "vtk"
  depends_on "webp"

  on_macos do
    depends_on "glew"
    depends_on "imath"
    depends_on "libarchive"
  end

  on_linux do
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "zlib-ng-compat"
  end

  def python3
    "python3.14"
  end

  # Drop the Caffe protobuf leftovers so DNN builds against external protobuf.
  patch do
    url "https://github.com/opencv/opencv/commit/f7ad23157f1b99b59bc9a706e9c7e4c8394947ac.patch?full_index=1"
    sha256 "3813186a3e0c7f8c366b11c64f112d31a4f8c9709de333a2532e85142bea25bf"
    type :backport
    resolves "https://github.com/opencv/opencv/pull/29425"
  end

  # Fix builds with FFmpeg 9.
  patch do
    url "https://github.com/opencv/opencv/commit/7551012b4e1c854c1dc36483c893f90b1c236977.patch?full_index=1"
    sha256 "0e662fbfd9949c4588138fcdb49bff124bf5e092ecfaa4db07938f50bb3ee1de"
    type :backport
    resolves "https://github.com/opencv/opencv/pull/29533"
  end

  patch do
    url "https://github.com/opencv/opencv/commit/a6f17e1f6a53f8bb016acfbcd55b61cbe220f5c8.patch?full_index=1"
    sha256 "f9fc79e1783debed6530600044c73f9a7d816c3b3095c260e1769bd04a62eb7d"
    type :backport
    resolves "https://github.com/opencv/opencv/pull/29662"
  end

  def install
    resource("contrib").stage buildpath/"opencv_contrib"

    # Finish PR #29425's file renames that `patch` leaves undone, then drop the emptied Caffe sources.
    { "modules/dnn/src/caffe/caffe_io.hpp"      => "modules/dnn/src/protobuf_io.hpp",
      "modules/dnn/src/caffe/glog_emulator.hpp" => "modules/dnn/src/glog_emulator.hpp" }
      .each { |from, to| mv from, to if File.exist?(from) && !File.exist?(to) }
    rm_r Dir["modules/dnn/src/caffe", "modules/dnn/misc/caffe"]

    # Avoid Accelerate.framework
    ENV["OpenBLAS_HOME"] = formula_opt_prefix("openblas")

    # Remove bundled libraries to make sure formula dependencies are used
    libdirs = %w[ffmpeg libjasper libjpeg-turbo libpng libtiff libwebp openjpeg protobuf tbb zlib]
    libdirs.each { |l| rm_r(buildpath/"3rdparty"/l) }

    # VTK 9.6 stopped transitively including <iostream>;
    # viz uses std::cout/endl directly.
    # PR refs: https://github.com/opencv/opencv_contrib/pull/4085
    inreplace "opencv_contrib/modules/viz/src/vtk/vtkVizInteractorStyle.cpp" do |s|
      s.sub! '#include "../precomp.hpp"', "#include <iostream>\n\\0"
      s.gsub!(/^(\s*)cout (<<.* )endl;$/, "\\1std::cout \\2std::endl;")
    end
    inreplace "opencv_contrib/modules/viz/src/widget.cpp", '#include "precomp.hpp"', "#include <iostream>\n\\0"

    args = %W[
      -DCMAKE_CXX_STANDARD=17
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
      -DWITH_OPENVINO=ON
      -DWITH_QT=OFF
      -DWITH_TBB=ON
      -DWITH_VTK=ON
      -DBUILD_opencv_python2=OFF
      -DBUILD_opencv_python3=ON
      -DPYTHON3_EXECUTABLE=#{which(python3)}
    ]

    args += if OS.mac?
      # Requires closed-source, pre-built Orbbec SDK on macOS
      ["-DWITH_OBSENSOR=OFF"]
    else
      # Disable precompiled headers and force opencv to use brewed libraries on Linux
      %W[
        -DENABLE_PRECOMPILED_HEADERS=OFF
        -DJPEG_LIBRARY=#{formula_opt_lib("jpeg-turbo")}/libjpeg.so
        -DOpenBLAS_LIB=#{formula_opt_lib("openblas")}/libopenblas.so
        -DOPENEXR_ILMIMF_LIBRARY=#{formula_opt_lib("openexr")}/libIlmImf.so
        -DOPENEXR_ILMTHREAD_LIBRARY=#{formula_opt_lib("openexr")}/libIlmThread.so
        -DPNG_LIBRARY=#{formula_opt_lib("libpng")}/libpng.so
        -DPROTOBUF_LIBRARY=#{formula_opt_lib("protobuf")}/libprotobuf.so
        -DPROTOBUF_INCLUDE_DIR=#{Formula["protobuf"].include}
        -DPROTOBUF_PROTOC_EXECUTABLE=#{Formula["protobuf"].bin}/protoc
        -DTIFF_LIBRARY=#{formula_opt_lib("libtiff")}/libtiff.so
        -DWITH_V4L=OFF
        -DZLIB_LIBRARY=#{formula_opt_lib("zlib-ng-compat")}/libz.so
      ]
    end

    # Ref: https://github.com/opencv/opencv/wiki/CPU-optimizations-build-options
    ENV.runtime_cpu_detection
    if Hardware::CPU.intel? && build.bottle?
      cpu_baseline = if OS.mac? && MacOS.version.requires_sse42?
        "SSE4_2"
      else
        "SSSE3"
      end
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
    (testpath/"test.cpp").write <<~CPP
      #include <opencv2/core.hpp>
      #include <opencv2/imgcodecs.hpp>
      #include <opencv2/opencv.hpp>
      #include <iostream>
      int main() {
        std::cout << CV_VERSION << std::endl;
        cv::Mat img = cv::imread("#{test_fixtures("test.jpg")}", cv::IMREAD_COLOR);
        if (img.empty()) {
          std::cerr << "Could not read test.jpg fixture" << std::endl;
          return 1;
        }
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}/opencv#{version.major}", "-o", "test",
                    "-L#{lib}", "-lopencv_core", "-lopencv_imgcodecs"
    assert_equal version.to_s, shell_output("./test").strip

    # The test below seems to time out on Intel macOS.
    return if OS.mac? && Hardware::CPU.intel?

    output = shell_output("#{python3} -c 'import cv2; print(cv2.__version__)'")
    assert_equal version.to_s, output.chomp
  end
end
