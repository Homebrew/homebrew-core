class OpencvAT3 < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://github.com/opencv/opencv/archive/3.4.16.tar.gz"
  sha256 "5e37b791b2fe42ed39b52d9955920b951ee42d5da95f79fbc9765a08ef733399"
  license "BSD-3-Clause"
  revision 10

  bottle do
    sha256 arm64_sonoma:   "e0644d0bf41b7937e68d64c2e3fed4fcd133d2a158c7c46f83d730ec91278a36"
    sha256 arm64_ventura:  "ba188e3c706ef89108f9cdb6db3431df48a57cec911e509bf08f659ea04ffc50"
    sha256 arm64_monterey: "2b43c5baa5a0a736c528996432e6760686fd577838793ce3a59f4b6842ff7a58"
    sha256 arm64_big_sur:  "aeae24c516413cad8f3aad18b79a714c6fab778a9ae6f5984862cbbe07cb10a4"
    sha256 sonoma:         "413f8f6114ebd5dd0af6a06fbc3a7395aaf068411faee4a582e9406a61e34880"
    sha256 ventura:        "ef372b5e6bb730c085b64cc87fe70c298e245bcadaa03fba1e455de524e1b69d"
    sha256 monterey:       "ac214b488450d231214ca239c3e5b364f94666daf24c643bedd507ca63347bfd"
    sha256 big_sur:        "b4ede37ae35dfd9e1ece7d711d7c01dc8ecafcc71e541370828e42a8d83824fb"
    sha256 x86_64_linux:   "418e78eefef39bb1bf0c3fa367818d207b385bf8e692f4925ca5a5ba7130d090"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
  depends_on "python@3.10"
  depends_on "tbb"
  depends_on "webp"

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

  # allow cmake to find OpenEXR 3+.
  patch do
    url "https://github.com/opencv/opencv/commit/f43fec7ee674d9fc65be21119066c3e67c856357.patch?full_index=1"
    sha256 "b46e4e9dc93878bccd2351c79795426797d27f54a4720d51f805c118770e6f4a"
  end

  # Fix build against lapack 3.10.0, https://github.com/opencv/opencv/pull/21114
  patch do
    url "https://github.com/opencv/opencv/commit/54c180092d2ca02e0460eac7176cab23890fc11e.patch?full_index=1"
    sha256 "66fd79afe33ddd4d6bb2002d56ca43029a68ab5c6ce9fd7d5ca34843bc5db902"
  end

  def python3
    "python3.10"
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
      args << "-DENABLE_SSE41=OFF" << "-DENABLE_SSE42=OFF" unless MacOS.version.requires_sse42?
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

    python = Formula["python@3.10"].opt_bin/python3
    ENV["PYTHONPATH"] = prefix/Language::Python.site_packages(python)
    output = shell_output("#{python} -c 'import cv2; print(cv2.__version__)'")
    assert_equal version.to_s, output.chomp
  end
end
