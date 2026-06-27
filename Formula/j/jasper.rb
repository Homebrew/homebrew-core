class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://ece.engr.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/releases/download/version-4.2.9/jasper-4.2.9.tar.gz"
  sha256 "f71cf643937a5fcaedcfeb30a22ba406912948ad4413148214df280afc425454"
  license "JasPer-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bc734fadc3ec13b979742b8be1aec388ae7ff06f514057253397af67f302ff96"
    sha256 cellar: :any,                 arm64_sequoia: "ff2667bbb901e39492d5e814f13d435ddc04dde4344e507cac25161c8797626b"
    sha256 cellar: :any,                 arm64_sonoma:  "2e320a3cb0f577443687d560be32f8a82a8656a639d9048a3f5a330aced98566"
    sha256 cellar: :any,                 sonoma:        "3405ea02f8b961bc9e3ffbe4129b3d357c8040a7290f29944d5dc875ffffd6fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55dd397df06c897cd1809379a46a825266001fc180ed5543014c30aaa4d0564e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42e56bdae47308719c6a31f311c8b5a0ffd11cb4d98e69e7a81309ab0245562d"
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
