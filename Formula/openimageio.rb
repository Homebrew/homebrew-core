class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.4.7.1.tar.gz"
  sha256 "fd298f71e44c6776863db4b37c4a1388dba0d2eb37378afea95ab07a7cd6ecd4"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "37fbf7b4b7229f362ce8d93748f7d8ade5cae84e0240b1acf8bf96c3c2ddc0f3"
    sha256 cellar: :any,                 arm64_monterey: "c48a6cf2544b9a584d2172112277554f52cfad11132ecf49618c1f43d9a0d9c0"
    sha256 cellar: :any,                 arm64_big_sur:  "6e04c12b059b5c06434821f72ffe10a2e64d9b5bf4f6666af910a15caa2f43c7"
    sha256 cellar: :any,                 ventura:        "e42caa9dc9f2c7ef89c955028b7beb0e6551dd4108b984e8598e16234198c039"
    sha256 cellar: :any,                 monterey:       "5d849692a43027b63718adc298b3a90ecd19aeb06172682cef972956e1dceaa8"
    sha256 cellar: :any,                 big_sur:        "b1a6a7d0b989de70430f5529d97690d79bac2e7510d17e38c2593fd7022f2c1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b38a3c1d1bd79481efa12948c6603172b1e8ef43c19d889d33a4126df5cc1ab9"
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
