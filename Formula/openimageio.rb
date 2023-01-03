class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.4.7.0.tar.gz"
  sha256 "c936ea78addad01a468debdc8a15844c0e7c081e2b64beb29d8713f7da565a80"
  license "BSD-3-Clause"
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a60b2240f2c815a3c80b27eeb9ebb7494e474864df08e57672b9f10f80ce70df"
    sha256 cellar: :any,                 arm64_monterey: "e5130004cb12bab62eb02d4c046ddbab2bd158f886728ec4ee23628e9bc57d36"
    sha256 cellar: :any,                 arm64_big_sur:  "7d2297f8682b97d6d3be10b2f64c66d0a2e3e4fec832159cad6f5447099e92fc"
    sha256 cellar: :any,                 ventura:        "8eaa445cd8717d472b9754753e9274b89642a4ccdedc4e275c59039f9b2e32f1"
    sha256 cellar: :any,                 monterey:       "6d0b9a53c0b1d9366ac3bd7c38a7f7aba9e72b09651ca3e5a553cfee153166c1"
    sha256 cellar: :any,                 big_sur:        "a073c3fb4d000f77c5d957544973ffce6f81d00c498122c94059d6e3e37a766e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e98c5e6c2a6cd9fcb6682e732998521a51f1e482fc569e0f086d6a740adc68b"
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
