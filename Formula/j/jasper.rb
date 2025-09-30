class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://ece.engr.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/releases/download/version-4.2.8/jasper-4.2.8.tar.gz"
  sha256 "98058a94fbff57ec6e31dcaec37290589de0ba6f47c966f92654681a56c71fae"
  license "JasPer-2.0"

  livecheck do
    url :stable
    regex(/^version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "643cf36ec42e5c52b20c786139c02ebbd07682021e3f7312685cb045984b272d"
    sha256 cellar: :any,                 arm64_sequoia: "923cc955de44c824d35a29760b7ae11a46e8ddfda4fe13a975077cceb1d19937"
    sha256 cellar: :any,                 arm64_sonoma:  "5e20916ebf8475692cf2c97b9bef688f98da5b3beb7fd8813eeef6e225077150"
    sha256 cellar: :any,                 arm64_ventura: "3edbecd302b5b65636f2ee9ea276a398af69c64be58de6c5f5dff082ac4a94eb"
    sha256 cellar: :any,                 sonoma:        "48fe7826a1387f0e7729edc0f1f08ce9fe25b64058ad475dc2915f96a13f8753"
    sha256 cellar: :any,                 ventura:       "6ca5a3246adf11b3303c2836d8d979e2b93d0205513f6e8c117579bbdc4f7502"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d113c75b426ac8131ca173fdb604306998cfb66b9f6a36257894345dc246ddbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea055410c941e2dbc5ef09000d86e339860b91a703c73aeb99f3e5d8021c4f02"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"

  def install
    args = %w[
      -DJAS_ENABLE_DOC=OFF
      -DJAS_ENABLE_AUTOMATIC_DEPENDENCIES=OFF
    ]

    args << if OS.mac?
      # Make sure macOS's GLUT.framework is used, not XQuartz or freeglut
      # Reported to CMake upstream 4 Apr 2016 https://gitlab.kitware.com/cmake/cmake/issues/16045
      glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
      "-DGLUT_glut_LIBRARY=#{glut_lib}"
    else
      "-DJAS_ENABLE_OPENGL=OFF"
    end

    # Build in the parent of `buildpath` to avoid errors from upstream's in-source build detection.
    system "cmake", "-S", ".", "-B", "../build-shared", "-DJAS_ENABLE_SHARED=ON", *args, *std_cmake_args
    system "cmake", "--build", "../build-shared"
    system "cmake", "--install", "../build-shared"

    system "cmake", "-S", ".", "-B", "../build-static", "-DJAS_ENABLE_SHARED=OFF", *args, *std_cmake_args
    system "cmake", "--build", "../build-static"
    lib.install "../build-static/src/libjasper/libjasper.a"

    # Move the build directories into `buildpath` so Homebrew captures log files properly.
    buildpath.install ["../build-shared", "../build-static"]

    # Avoid rebuilding dependents that hard-code the prefix.
    inreplace lib/"pkgconfig/jasper.pc", prefix, opt_prefix
  end

  test do
    system bin/"jasper", "--input", test_fixtures("test.jpg"),
                         "--output", "test.bmp"
    assert_path_exists testpath/"test.bmp"
  end
end
