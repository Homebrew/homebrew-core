class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/AcademySoftwareFoundation/OpenImageIO/archive/refs/tags/v2.5.6.0.tar.gz"
  sha256 "bcfced40a25ef8576383b44d8bbe3732aa2b8efc7b8614482783d6f90378d307"
  license "Apache-2.0"
  head "https://github.com/AcademySoftwareFoundation/OpenImageIO.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8680390374a02ce1840f19d178412aa08bf65d6201abe39b1cc43f8e8b23582d"
    sha256 cellar: :any,                 arm64_ventura:  "3f0698008d1ecbadf124e1cfa57d191e3d7388fbaa749cfe9d3d3e61aedb37d7"
    sha256 cellar: :any,                 arm64_monterey: "6fb39a17b5b2baa9fd04b1126ccc4b0e23346681b98cf1e4aacaa992b97759da"
    sha256 cellar: :any,                 sonoma:         "c8b3491dbda572944e9cb4c8f1e4e6507f54d3e5579e80f74441c7d04e17158a"
    sha256 cellar: :any,                 ventura:        "1402ca03d66dd66021e7b8fb18cc7edfc211e49f282621927e8e103e2ea4bde0"
    sha256 cellar: :any,                 monterey:       "a8b11e11078f2e842ccc3ec050ce7c1babff6b2ff60dc2d109c3aa1476ecc85e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b20369fa3c005d8d8493846a60261cbe1e7dff3d99cb84cef6598927580f87f"
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
  depends_on "python@3.12"
  depends_on "webp"

  # https://github.com/AcademySoftwareFoundation/OpenImageIO/blob/master/INSTALL.md
  fails_with :gcc do
    version "5"
    cause "Requires GCC 6.1 or later"
  end

  def python3
    "python3.12"
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
