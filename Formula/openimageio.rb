class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.4.4.2.tar.gz"
  sha256 "1ae437e1178f53a972d8b42147d7571c5463652a638b36526f25d5719becbb55"
  license "BSD-3-Clause"
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d891771f2f7c4013b4f76b2071a2ce21a8f3e52628620a6cadb0b8acd14401d1"
    sha256 cellar: :any,                 arm64_big_sur:  "ef65e0502ad664ab82ec9c079cc025fd57e6eb87724e5eea8778d6252aa6dd3e"
    sha256 cellar: :any,                 monterey:       "494731a44d8bf2ad10df7a93f838cae20408015f74b86d8cc3d0f9e72858e8d3"
    sha256 cellar: :any,                 big_sur:        "880120fbddf7dbcca15835085cb460cbe6e3236374560178df2448be25b66ab3"
    sha256 cellar: :any,                 catalina:       "2322386cae9406140089e81629c193655d48666813a27065a0c52261af3b680e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ead23c38e2ca582d9e896354c54bdccc1e2be504dbe40ed74acda379b5a129bd"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "ffmpeg"
  depends_on "fmt"
  depends_on "freetype"
  depends_on "giflib"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "libtiff"
  depends_on "opencolorio"
  depends_on "openexr"
  depends_on "pugixml"
  depends_on "pybind11"
  depends_on "python@3.10"
  depends_on "webp"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    python3 = which("python3.10")
    py3ver = Language::Python.major_minor_version python3
    ENV["PYTHONPATH"] = prefix/Language::Python.site_packages(python3)

    args = %W[
      -DPython_EXECUTABLE=#{python3}
      -DPYTHON_VERSION=#{py3ver}
      -DBUILD_MISSING_FMT=OFF
      -DCCACHE_FOUND=
      -DEMBEDPLUGINS=ON
      -DOIIO_BUILD_TESTS=OFF
      -DUSE_EXTERNAL_PUGIXML=ON
      -DUSE_JPEGTURBO=ON
      -DUSE_NUKE=OFF
      -DUSE_OPENCV=OFF
      -DUSE_OPENGL=OFF
      -DUSE_OPENJPEG=OFF
      -DUSE_PTEX=OFF
      -DUSE_QT=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match "#{test_image} :    1 x    1, 3 channel, uint8 jpeg",
                 shell_output("#{bin}/oiiotool --info #{test_image} 2>&1")

    output = <<~EOS
      from __future__ import print_function
      import OpenImageIO
      print(OpenImageIO.VERSION_STRING)
    EOS
    python = Formula["python@3.10"].opt_bin/"python3.10"
    assert_match version.major_minor_patch.to_s, pipe_output(python, output, 0)
  end
end
