class OpencvAT4 < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  url "https://github.com/opencv/opencv/archive/refs/tags/4.14.0.tar.gz"
  sha256 "ee8fb9b30eb60850431b4656447080e3737b56e45719c92b67f245950609f86e"
  license all_of: [
    "Apache-2.0",
    "BSD-3-Clause", # modules/xfeatures2d/src/kaze/, 3rdparty/ittnotify/, ...
    "MIT",          # modules/gapi/src/3rdparty/vasot
  ]
  revision 12
  compatibility_version 2

  livecheck do
    url :stable
    regex(/^v?(4(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "bcb4f434944eab53c389d7f11f086a61cb2d3890ba6a264defcbfb52dd4ab5b2"
    sha256 arm64_golden_gate: "fa3cc579f9fba9339a5ccad0fd853138277f8a4d25b3edeb8196661181fb2437"
    sha256 arm64_tahoe:       "b0408885e97472440ba355272b02c375386d807f0ae167096c933699198d9162"
    sha256 arm64_sequoia:     "5bb8b3b20a22894425ac1835ad2f999c13ea5c0017f7685287da88bca3f78feb"
    sha256 arm64_linux:       "2bb3b132b0b7e4817a1e94e379205c430cf7c12084722fe6d65ab2a230dbd358"
    sha256 x86_64_linux:      "cc35a942304806c7b34c5ea5ac9f4636b237a645da0cdd6672191ac142179bd7"
  end

  keg_only :versioned_formula

  deprecate! date: "2026-10-09", because: :unsupported
  disable! date: "2027-07-09", because: :unsupported

  depends_on "ade" => :build
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
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "numpy" => :no_linkage
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

  on_linux do
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "jsoncpp"
    depends_on "zlib-ng-compat"
  end

  resource "contrib" do
    url "https://github.com/opencv/opencv_contrib/archive/refs/tags/4.14.0.tar.gz"
    sha256 "4f17abd1bc7f88e19c3380c8de7cbf2d863aced5b5ee8d8934cc7902b67d42c9"

    livecheck do
      formula :parent
    end

    # Backport missing iostream include
    patch do
      url "https://github.com/opencv/opencv_contrib/commit/b57ddd9c3fa4873bc6832c74155b0054779b0c1f.patch?full_index=1"
      sha256 "83c5e812d5786a700cb4f0db02264a16140e5f3ee426e03bf789298d43b102ec"
      type :backport
    end
  end

  # ARM-only but not using on_arm block so that autobump can update resource
  resource "kleidicv" do
    url "https://gitlab.arm.com/kleidi/kleidicv/-/archive/26.03/kleidicv-26.03.tar.gz"
    sha256 "1bb4078fd215565f3906c33f76a00e7b843328965230d765afcd0d51141c434f"

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
    libdirs = %w[ffmpeg libjasper libjpeg libjpeg-turbo libpng libtiff libwebp openexr openjpeg protobuf tbb zlib]
    libdirs.each { |l| rm_r(buildpath/"3rdparty"/l) }

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
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}/opencv4", "-o", "test",
                    "-L#{lib}", "-lopencv_core", "-lopencv_imgcodecs"
    assert_equal version.to_s, shell_output("./test").strip

    ENV.prepend_path "PYTHONPATH", prefix/Language::Python.site_packages(python3)
    output = shell_output("#{python3} -c 'import cv2; print(cv2.__version__)'")
    assert_equal version.to_s, output.chomp
  end
end
