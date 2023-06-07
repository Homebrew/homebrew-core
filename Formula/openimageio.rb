class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.4.12.0.tar.gz"
  sha256 "1576eb9b805998e684014688528c8e63958edba3a8b01073a10266b999f4c674"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "225d83e780ed84211130a22283939339a4cbabb9aee3f0ae98581a0b3495ab7d"
    sha256 cellar: :any,                 arm64_monterey: "713a4ce1392c3419e58e0cab78045b2b1168fd649e3fefe681d37e6d738b699b"
    sha256 cellar: :any,                 arm64_big_sur:  "11c6d5a077454e1b74f35da230d75537ae02f9378e2897ee3b4ccaf98ef82cab"
    sha256 cellar: :any,                 ventura:        "f22dc38d4784e75f8a9c7877e0142dc1e6b32cd03c9a0419fc37762e7fe99bcb"
    sha256 cellar: :any,                 monterey:       "44edd849062bf1f746bf5293725f78f8a12b79ff70dd0679bbc1a66581c150dd"
    sha256 cellar: :any,                 big_sur:        "29d36b48c7e5d47cedd9c9c4b83faa7337f9619b95f44a24725d9605f16768c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "babd92420e0cb1f6afcad6558b5f228addaa0e991f5866f89a506a017ea75a6d"
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
