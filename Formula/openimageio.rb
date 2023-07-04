class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.4.13.0.tar.gz"
  sha256 "72b7d2d5edd1049bb7fc09becad4d8be64a9918cdf79bae98b4b32e1fda762cd"
  license "BSD-3-Clause"
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ee574a4f0eac8aed0162b3e898b9ca8b6a96c9e7df9cb2b4f8775bb8e7aa161c"
    sha256 cellar: :any,                 arm64_monterey: "370a87a86c8231bf66c6a610d1d5908dd1a25bc2a44d7929fdcc420c5eb7af53"
    sha256 cellar: :any,                 arm64_big_sur:  "1c05ca9929691560361af87ef3f9e048df44f738ce207a69df99277704a8109f"
    sha256 cellar: :any,                 ventura:        "ee5fea2b9aeb32a049cb1a659256f2db268caf1104f9e233ef272c338274e2cc"
    sha256 cellar: :any,                 monterey:       "6b3fa05da0546b4d2bc2b998271cfe8c85571cd4ad7c68df40180fff8fcdd004"
    sha256 cellar: :any,                 big_sur:        "1c1f20efe15386c5635a226779a3757603e8de921c39dea99faf7a9783d32351"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92ffec6ecb7018295206c7933838282e918f5ebcaa3245a30b7082c5e8356141"
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
