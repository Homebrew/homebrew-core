class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.4.10.0.tar.gz"
  sha256 "59f523a0b9a1014993bedcf7752993af43b348761165f52ea6eb84787f57aed5"
  license "BSD-3-Clause"
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "991381655dbd08f6ef811da078269f2c7e587560c5d0f8fb1b76150b2a01a14c"
    sha256 cellar: :any,                 arm64_monterey: "143842cfb0a4b70b6eac92b236f7939e8e1b205c7ce115b992da8544e6613d5f"
    sha256 cellar: :any,                 arm64_big_sur:  "0bc68786484e29199a714d8b31bc495ffa76c2b4a0ee1ca68e071fff55ade658"
    sha256 cellar: :any,                 ventura:        "0734391e9b8cb48e17317951c93a018a9f4a3a241070ea3cf73c75c7e8359309"
    sha256 cellar: :any,                 monterey:       "c778921815540f2a2aa429d1830dc176d5970a3852cd0c0e0012176f7696b7a9"
    sha256 cellar: :any,                 big_sur:        "e3f91f55037220c50bb1f65050e0b2dd0b999e8423cebc34d5bd79f861a1ab70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "822d6c628825f603f3f1f1fc39e447d4b718b67f7d8950566cda4771cbd05205"
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
  depends_on "python@3.11"
  depends_on "webp"

  # https://github.com/OpenImageIO/oiio/blob/master/INSTALL.md
  fails_with :gcc do
    version "5"
    cause "Requires GCC 6.1 or later"
  end

  def python3
    "python3.11"
  end

  def install
    py3ver = Language::Python.major_minor_version python3
    ENV["PYTHONPATH"] = prefix/Language::Python.site_packages(python3)

    args = %W[
      -DPython_EXECUTABLE=#{which(python3)}
      -DPYTHON_VERSION=#{py3ver}
      -DBUILD_MISSING_FMT=OFF
      -DCCACHE_FOUND=
      -DEMBEDPLUGINS=ON
      -DOIIO_BUILD_TESTS=OFF
      -DUSE_DCMTK=OFF
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
    assert_match version.major_minor_patch.to_s, pipe_output(python3, output, 0)
  end
end
