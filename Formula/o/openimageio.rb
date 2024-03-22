class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.readthedocs.io/en/stable/"
  url "https://github.com/AcademySoftwareFoundation/OpenImageIO/archive/refs/tags/v2.5.9.0.tar.gz"
  sha256 "b6a68e369bc475525eb843bdc0cb8adc910cc71000825f8db9b5e136166cdc78"
  license "Apache-2.0"
  head "https://github.com/AcademySoftwareFoundation/OpenImageIO.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b186d4328428013da60aa2f54dc28ae8fe9121e49950c15355e6aaf6740c1a98"
    sha256 cellar: :any,                 arm64_ventura:  "14cccedb20e13fe795af33d3114b3b274e287b44b105d64eb7df089f4190c365"
    sha256 cellar: :any,                 arm64_monterey: "53926fe43a8fb7b73852935dee30eba1d39699bc46319817484b96d9d0730605"
    sha256 cellar: :any,                 sonoma:         "baee6b3a1cf9ff007f8d5bab1c50981ad932968506539654fe020dba7ce13da8"
    sha256 cellar: :any,                 ventura:        "14f588471c0b8cddce3439d32799cc451a529da83517a20c1ce92457d37a92cf"
    sha256 cellar: :any,                 monterey:       "21e38e091e83a4527a3081dc1422116d2eb94485c9797708a47b0997d3f31467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19c875d1f64c95781d5051d460176177acb71f73d570063eee0ffba76e65b245"
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
