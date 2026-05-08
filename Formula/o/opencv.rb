class Opencv < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  license "Apache-2.0"
  revision 10
  compatibility_version 1

  stable do
    url "https://github.com/opencv/opencv/archive/refs/tags/4.13.0.tar.gz"
    sha256 "1d40ca017ea51c533cf9fd5cbde5b5fe7ae248291ddf2af99d4c17cf8e13017d"

    resource "contrib" do
      url "https://github.com/opencv/opencv_contrib/archive/refs/tags/4.13.0.tar.gz"
      sha256 "1e0077a4fd2960a7d2f4c9e49d6ba7bb891cac2d1be36d7e8e47aa97a9d1039b"

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
    sha256 arm64_tahoe:   "123b6d8860c3835290e3e58ab9af96b638c1bc162163f2880935f27abe58b387"
    sha256 arm64_sequoia: "4255631e4cc70e700d7bf3e126a618364c7cf7dee522bd1dbc4360a973b34889"
    sha256 arm64_sonoma:  "454f705d2a2abcb20db11260b6b7ea007c1b05d7a843a97ac38e4ffee62a88c1"
    sha256 sonoma:        "c668b081315ed90dc6b97c29a393b8bc10be9334083847b3517a859450701a42"
    sha256 arm64_linux:   "dcefcc3a3a40d2b77b07438ed95a35522966339f6a07a709a0eed8edede591a5"
    sha256 x86_64_linux:  "71dc6c4101a7e1e4855b05f1086dc4132ec825b5b2ccef6313235744edbf862c"
  end

  head do
    url "https://github.com/opencv/opencv.git", branch: "4.x"

    resource "contrib" do
      url "https://github.com/opencv/opencv_contrib.git", branch: "4.x"
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

  def install
    resource("contrib").stage buildpath/"opencv_contrib"

    # Avoid Accelerate.framework
    ENV["OpenBLAS_HOME"] = Formula["openblas"].opt_prefix

    # Remove bundled libraries to make sure formula dependencies are used
    libdirs = %w[ffmpeg libjasper libjpeg libjpeg-turbo libpng libtiff libwebp openexr openjpeg protobuf tbb zlib]
    libdirs.each { |l| rm_r(buildpath/"3rdparty"/l) }

    # Fix OpenVINO 2026 Tensor::data() constness mismatch, upstream bug report, https://github.com/opencv/opencv/issues/28586
    inreplace "modules/dnn/src/op_inf_engine.cpp",
              "return Mat(size, type, blob.data());",
              "return Mat(size, type, const_cast<void*>(blob.data()));"

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
        -DJPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_lib}/libjpeg.so
        -DOpenBLAS_LIB=#{Formula["openblas"].opt_lib}/libopenblas.so
        -DOPENEXR_ILMIMF_LIBRARY=#{Formula["openexr"].opt_lib}/libIlmImf.so
        -DOPENEXR_ILMTHREAD_LIBRARY=#{Formula["openexr"].opt_lib}/libIlmThread.so
        -DPNG_LIBRARY=#{Formula["libpng"].opt_lib}/libpng.so
        -DPROTOBUF_LIBRARY=#{Formula["protobuf"].opt_lib}/libprotobuf.so
        -DPROTOBUF_INCLUDE_DIR=#{Formula["protobuf"].include}
        -DPROTOBUF_PROTOC_EXECUTABLE=#{Formula["protobuf"].bin}/protoc
        -DTIFF_LIBRARY=#{Formula["libtiff"].opt_lib}/libtiff.so
        -DWITH_V4L=OFF
        -DZLIB_LIBRARY=#{Formula["zlib-ng-compat"].opt_lib}/libz.so
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
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}/opencv4", "-o", "test",
                    "-L#{lib}", "-lopencv_core", "-lopencv_imgcodecs"
    assert_equal version.to_s, shell_output("./test").strip

    # The test below seems to time out on Intel macOS.
    return if OS.mac? && Hardware::CPU.intel?

    output = shell_output("#{python3} -c 'import cv2; print(cv2.__version__)'")
    assert_equal version.to_s, output.chomp
  end
end
