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
    sha256 cellar: :any,                 arm64_ventura:  "de6ae87df482c4fcd7c09e05c027e2c378133572df88e580984bdd50e7d17157"
    sha256 cellar: :any,                 arm64_monterey: "59f498bacc249b5045e34f2da9e51ea91f0061176fc682e0c8aff0941a436c80"
    sha256 cellar: :any,                 arm64_big_sur:  "f6fdcb6d0032e5dd4b43a618a2983c9c8ca1073d7b8772743eb721fbe2b4400f"
    sha256 cellar: :any,                 ventura:        "22e0b351d699d82241cbbead348bbbd5e001b6310fc65325c10499cfc9dbec98"
    sha256 cellar: :any,                 monterey:       "d250f9f1b83f47abcf39018e2987b2d190989ec7f18d482e3ecf175bdf02612d"
    sha256 cellar: :any,                 big_sur:        "2fb299bdfcb6ea1a09d700901818ec902f59f15c192e1931af1ed9f56be94484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d9552ff87eba548746ff1142599e221bf6d2ac701c09ffd5d8efca79421dc83"
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
