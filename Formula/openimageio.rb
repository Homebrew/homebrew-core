class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.4.5.0.tar.gz"
  sha256 "21177a9665021a99123885cd8383116d15013b6610b4b09bcf209612423fedc5"
  license "BSD-3-Clause"
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "86e3e547dec901770c363228bd7cc6922480fff1dfa6ccdb739304e340c4d882"
    sha256 cellar: :any,                 arm64_big_sur:  "e1d780abce699d3fb4a5df66dd6228da33addb6491e6f3feaeea61175c6d206f"
    sha256 cellar: :any,                 monterey:       "826e7a7d6bb2b7cd6fde3d4a9366865d423e579308de4d3d0d5a8115e77788e3"
    sha256 cellar: :any,                 big_sur:        "47857c0e321f0b644b25df336368b14cdac19757804e8c80bc891b7215fe0627"
    sha256 cellar: :any,                 catalina:       "2ac524293c89ac4ad679a837e3d7908cedeb6775d4a78bcf175d825b83722192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9ee0e155d8f2fa966b7f175178abb21e63d02f10a423ed96c7df999a6d1570a"
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
