class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.4.11.0.tar.gz"
  sha256 "51390b3e7222892e87eb929d227bbb5b9be9f7bf3b47229a91d2b106ebffb3fb"
  license "BSD-3-Clause"
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "69f59312e96e7fc0eef02a54c34e86915cacf1d2f09fd8f518d0f625bc6ad475"
    sha256 cellar: :any,                 arm64_monterey: "a67444df798aff18e5cd1750441600cd800a54c3c7140d3e5ea9fad2fc85dfd1"
    sha256 cellar: :any,                 arm64_big_sur:  "1451a1fd1f22c68fa298db367316bc3062532c91c97f3fc2b6e195e08759b6d1"
    sha256 cellar: :any,                 ventura:        "d2844119b82e3f057ae94cbec755f43a3341dcd149a7fdcffa83979ce395715f"
    sha256 cellar: :any,                 monterey:       "e21932c0fcd8199d18a231c8488674990abbe411a273040dda3735f6f300b6b5"
    sha256 cellar: :any,                 big_sur:        "a3e0a336c8a2c99d64d0356579ba78144a893c5bf41b4004246d782efc52ddfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "156ce90ba81017b865b0b356dd938e137a48e6c81c7392fb22f59390adcdd2d9"
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
