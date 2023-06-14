class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.4.12.0.tar.gz"
  sha256 "1576eb9b805998e684014688528c8e63958edba3a8b01073a10266b999f4c674"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c05d3b5b55bd09ceaa75ddf57c021a3aa1f08492327b37af74698cf4844ebdc1"
    sha256 cellar: :any,                 arm64_monterey: "e3a5bc12de8796ebb11ae1139d475c712e55e31cbc92825a37c5b271647a6d6f"
    sha256 cellar: :any,                 arm64_big_sur:  "c54c78306a97e05d13f78ed95355fdbf1b06c0763ba7b858e0a619a069a4ab90"
    sha256 cellar: :any,                 ventura:        "a91ed705e10fc2c5553e00e3eebe1bf485dd67156ab48866fc35e7cf68a58eb7"
    sha256 cellar: :any,                 monterey:       "e8954a22150f166412e7c50c864cfd8430044d6e2d5b62f442369b964b846aab"
    sha256 cellar: :any,                 big_sur:        "9c2b501aa406ab69be9e89fd15a4e93cfbab9a9dd6cf4402bb2f9119e1870eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0245372229034ef1bda55ab0dc60c3b843fa0d7fb794e91b60ed9f64809bd01c"
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
