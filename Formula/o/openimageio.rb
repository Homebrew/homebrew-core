class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.4.15.0.tar.gz"
  sha256 "b2d76e3880d25d3b005f7c694811a991ccebb6e396965959d194f79c369ff390"
  license "Apache-2.0"
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "400a69c58806b292ca12670fad48541eb1d675bde161af66c2f01a90b0a5fda3"
    sha256 cellar: :any,                 arm64_monterey: "bd4256cbb88e5dbbfd8f07235066c9e01ac29b20b2f97ae39c620e012abcdffb"
    sha256 cellar: :any,                 arm64_big_sur:  "23cb5bdb95bb8a020714a987cb96e5886a37f83ca9e734576ea699ed53b7c0d9"
    sha256 cellar: :any,                 ventura:        "143444491eaf438870fa6a235375b07f88e9b64a2d5a7fa9bd1a0417ccc2208a"
    sha256 cellar: :any,                 monterey:       "d7e300c91e3c47cbf6c5429137a9e29b5bbbb63ded152bb4f71f0994fb63598a"
    sha256 cellar: :any,                 big_sur:        "bfc9773d39b5d138b0ec07b9c70e0def5b319856c42eff5708d8694f827ab906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "642de0ad359630bd52a1fc3ea1b6b3e5a01a780198f9a2bc2203bfdb71f61b0c"
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
