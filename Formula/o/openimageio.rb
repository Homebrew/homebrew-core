class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.4.14.0.tar.gz"
  sha256 "92ad4b107394b273397baa1abe90207e1f8ef9fd52ffbfc23b46e3b0005d4439"
  license "Apache-2.0"
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "22c9096d03d076b28c21d87bf6f5c6ca9fea12daaced8f9f533d8ccf77f33a02"
    sha256 cellar: :any,                 arm64_monterey: "27269b6aa11ed491f8fd41339b27095a4f0e862ff0d60bb80a7aa5f12f4455da"
    sha256 cellar: :any,                 arm64_big_sur:  "c6493bc9cfed4494d3a88235397fb247a7eaca1b21f24707c9199356eb943245"
    sha256 cellar: :any,                 ventura:        "33669c84c924d005504a34a9565c0aa54e4bf6ed9ef8811aee150ad92ae33de1"
    sha256 cellar: :any,                 monterey:       "15c1242d1e0667b9c3829c813241f7d339e9d9555bd62966956a791f4c600718"
    sha256 cellar: :any,                 big_sur:        "4f3b350467ec04d0fc8b61ae0b156bba55427fb2584fda35b207c49715584b94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01f00d5e12311263470c0e1870f659ac0c37ea3686ea47ae02a87e3ae890a213"
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
