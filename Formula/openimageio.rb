class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.4.8.0.tar.gz"
  sha256 "e8402851970d48c718917060fa79bb7d75a050316556337cd0d4f0d0f971c904"
  license "BSD-3-Clause"
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "66e29da7f537cc25964d7b2ea8eb6d60d7f3835322a0bf51effec14347aed794"
    sha256 cellar: :any,                 arm64_monterey: "0301c6af8d606cfb5472a436519f86d57820be8a23dbacb73be6884971f6bfc2"
    sha256 cellar: :any,                 arm64_big_sur:  "a9f59382b68b8ca2c8425d2130936b1ddd2468687cb37774913cf4f60c6eb5d9"
    sha256 cellar: :any,                 ventura:        "4ffd3ba2f6dc4b21d75459d8c3c9d023c8cea4499f76f85b87cf4e7568101fd4"
    sha256 cellar: :any,                 monterey:       "8b8b4f8e2660fb6662e09629ea56d81514abb053120bc26d39150af0a31bdece"
    sha256 cellar: :any,                 big_sur:        "1abf007702f3d8c8bf42195e0b55cf0b5ee8d5077ebec7e6aba572481c48827b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5fd55774aaf21451cee7285319bfba7164f56ab94ae1f4034819dd2de6644e8"
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
