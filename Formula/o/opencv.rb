class Opencv < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  license all_of: [
    "Apache-2.0",
    "BSD-3-Clause",   # modules/xfeatures2d/src/kaze/, 3rdparty/ittnotify/, ...
    "MIT",            # modules/gapi/src/3rdparty/vasot
    "OFL-1.1-no-RFN", # modules/imgproc/fonts/
  ]
  compatibility_version 3

  stable do
    url "https://github.com/opencv/opencv/archive/refs/tags/5.1.0.tar.gz"
    sha256 "638c1dae7e37e45afea21aa217dc667ad7cf57acc66cdf652c074f1e0e5ad6d2"

    resource "contrib" do
      url "https://github.com/opencv/opencv_contrib/archive/refs/tags/5.1.0.tar.gz"
      sha256 "6aee68285f0e7b7bf77d3656bc6568820c6f15704860fc0922def357d40ebeff"

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
    rebuild 1
    manifest_sha256 "31b77bf79c683148a4df49ffe1226f95eb9dc7df73e9d47950b56cf23d10bd09"
    sha256 arm64_golden_gate: "b653eda09fb93da95f2cb9a8fa99a8cfd6546127e04f6294d7e54005f4f651bf"
    sha256 arm64_tahoe:       "2f4bdd0e11e04ed4c6a997530615af5afd71542f23ff29b2dac47669359b4acc"
    sha256 arm64_sequoia:     "dca771e7e2b93af7befd4d020a1ced930b2c76df401eac50ea6f69cc25e778f6"
    sha256 arm64_linux:       "62ddf59288fe9338dc4a362c2c553a95b712431d06fc87d84e0eed4950dde6d1"
    sha256 x86_64_linux:      "3139494d4d4dc90bfc231967be4a453eba0cb4af3622719df4406f5ee4b80a3e"
  end

  head do
    url "https://github.com/opencv/opencv.git", branch: "5.x"

    resource "contrib" do
      url "https://github.com/opencv/opencv_contrib.git", branch: "5.x"
    end
  end

  depends_on "ade" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "ceres-solver"
  depends_on "eigen"
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "gflags"
  depends_on "glog"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libavif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "numpy" => :no_linkage
  depends_on "openblas"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "openvino"
  depends_on "protobuf"
  depends_on "python@3.15"
  depends_on "tbb"
  depends_on "tesseract"
  depends_on "vtk"
  depends_on "webp"

  on_linux do
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "jsoncpp"
    depends_on "zlib-ng-compat"
  end

  # ARM-only but not using on_arm block so that autobump can update resource
  resource "kleidicv" do
    url "https://gitlab.arm.com/kleidi/kleidicv/-/archive/26.09/kleidicv-26.09.tar.gz"
    sha256 "9b18ee6c4ce17ea936c4c4aaea2638e8cd6b072a10eb801011a7aa93e14f877d"

    livecheck do
      url "https://raw.githubusercontent.com/opencv/opencv/refs/tags/#{LATEST_VERSION}/hal/kleidicv/kleidicv.cmake"
      regex(/KLEIDICV_SRC_COMMIT "(\d+(?:\.\d+)+)"/i)
    end
  end

  resource "wechat_qrcode" do
    url "https://github.com/WeChatCV/opencv_3rdparty/archive/a8b69ccc738421293254aec5ddb38bd523503252.tar.gz"
    version "a8b69ccc738421293254aec5ddb38bd523503252"
    sha256 "7a16ad6ca511c620c2a4cbef2c7cf1ff5c31bd530ac7b43ee2ea8481683df20a"

    livecheck do
      url "https://raw.githubusercontent.com/opencv/opencv_contrib/refs/tags/#{LATEST_VERSION}/modules/wechat_qrcode/CMakeLists.txt"
      regex(/wechat_qrcode_commit_hash "(\h+)"/i)
    end
  end

  resource "xfeatures2d/boostdesc" do
    url "https://github.com/opencv/opencv_3rdparty/archive/34e4206aef44d50e6bbcd0ab06354b52e7466d26.tar.gz"
    version "34e4206aef44d50e6bbcd0ab06354b52e7466d26"
    sha256 "d93c783cdf799da7e4a9209d169390424c4c198c1c9b5eeb78ffc890afe5f332"

    livecheck do
      url "https://raw.githubusercontent.com/opencv/opencv_contrib/refs/tags/#{LATEST_VERSION}/modules/xfeatures2d/cmake/download_boostdesc.cmake"
      regex(/OPENCV_3RDPARTY_COMMIT "(\h+)"/i)
    end
  end

  resource "xfeatures2d/vgg" do
    url "https://github.com/opencv/opencv_3rdparty/archive/fccf7cd6a4b12079f73bbfb21745f9babcd4eb1d.tar.gz"
    version "fccf7cd6a4b12079f73bbfb21745f9babcd4eb1d"
    sha256 "e9abccbabcace092e5424073168cc86d422585d15d25569f01fb6503b109e0e1"

    livecheck do
      url "https://raw.githubusercontent.com/opencv/opencv_contrib/refs/tags/#{LATEST_VERSION}/modules/xfeatures2d/cmake/download_vgg.cmake"
      regex(/OPENCV_3RDPARTY_COMMIT "(\h+)"/i)
    end
  end

  resource "face_landmark_model.dat" do
    url "https://raw.githubusercontent.com/opencv/opencv_3rdparty/8afa57abc8229d611c4937165d20e2a2d9fc5a12/face_landmark_model.dat"
    version "8afa57abc8229d611c4937165d20e2a2d9fc5a12"
    sha256 "eeab592db2861a6c94d592a48456cf59945d31483ce94a6bc4d3a4e318049ba3"

    livecheck do
      url "https://raw.githubusercontent.com/opencv/opencv_contrib/refs/tags/#{LATEST_VERSION}/modules/face/CMakeLists.txt"
      regex(/__commit_hash "(\h+)"/i)
    end
  end

  deny_network_access!

  def install
    resource("contrib").stage buildpath/"opencv_contrib"
    %w[build_shared build_static].each do |builddir|
      resource("wechat_qrcode").stage buildpath/builddir/"downloads/wechat_qrcode"
      resource("xfeatures2d/boostdesc").stage buildpath/builddir/"downloads/xfeatures2d"
      resource("xfeatures2d/vgg").stage buildpath/builddir/"downloads/xfeatures2d"
      resource("face_landmark_model.dat").stage buildpath/builddir/"share/opencv#{version.major}/testdata/cv/face"
    end

    # Avoid Accelerate.framework
    ENV["OpenBLAS_HOME"] = formula_opt_prefix("openblas")

    # Remove bundled libraries to make sure formula dependencies are used
    libdirs = %w[ffmpeg harfbuzz libjasper libjpeg-turbo libpng libtiff libwebp openjpeg protobuf tbb zlib]
    libdirs.each { |l| rm_r(buildpath/"3rdparty"/l) }

    # contrib freetype's own harfbuzz check overwrites the `HARFBUZZ_LIBRARIES` set for imgproc,
    # dropping `harfbuzz-raster` and leaving `hb_raster_*` symbols undefined
    # Issue ref: https://github.com/opencv/opencv/issues/29458
    inreplace "opencv_contrib/modules/freetype/CMakeLists.txt", "HARFBUZZ", "FT_HARFBUZZ"

    args = %W[
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DBUILD_HARFBUZZ=OFF
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
      -DWITH_AVIF=ON
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
      -DPYTHON3_EXECUTABLE=#{python3}
      -Dade_DIR=#{Formula["ade"].opt_pkgshare}
    ]

    # Requires closed-source, pre-built Intel IPP library
    args << "-DWITH_IPP=OFF"

    args += if OS.mac?
      # Requires closed-source, pre-built Orbbec SDK on macOS
      %w[
        -DWITH_OBSENSOR=OFF
        -DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs
      ]
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
        -DPROTOBUF_INCLUDE_DIR=#{formula_opt_include("protobuf")}
        -DPROTOBUF_PROTOC_EXECUTABLE=#{formula_opt_bin("protobuf")}/protoc
        -DTIFF_LIBRARY=#{formula_opt_lib("libtiff")}/libtiff.so
        -DWITH_V4L=OFF
        -DZLIB_LIBRARY=#{formula_opt_lib("zlib-ng-compat")}/libz.so
      ]
    end

    if Hardware::CPU.arm64?
      resource("kleidicv").stage buildpath/"kleidicv"
      args << "-DKLEIDICV_SOURCE_PATH=#{buildpath}/kleidicv"
    end

    # Ref: https://github.com/opencv/opencv/wiki/CPU-optimizations-build-options
    ENV.runtime_cpu_detection

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
        if (!cv::haveImageWriter("test.avif") || !cv::imwrite("test.avif", img)) {
          std::cerr << "Could not write AVIF image" << std::endl;
          return 1;
        }
        cv::Mat avif = cv::imread("test.avif", cv::IMREAD_COLOR);
        if (avif.empty() || avif.size() != img.size() || avif.type() != img.type()) {
          std::cerr << "Could not read AVIF image with the expected dimensions and type" << std::endl;
          return 1;
        }
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}/opencv#{version.major}", "-o", "test",
                    "-L#{lib}", "-lopencv_core", "-lopencv_imgcodecs"
    assert_equal version.to_s, shell_output("./test").strip

    output = shell_output("#{python3} -c 'import cv2; print(cv2.__version__)'")
    assert_equal version.to_s, output.chomp
  end
end
