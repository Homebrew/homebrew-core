class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.4.9.0.tar.gz"
  sha256 "d04c12575d63d13ed64fc037ea37da616224736213d785de9f50337f6eb5a9ed"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "339997823fb89cae4c8e7fd020b8cb37a580e60ecfaeb4f3f4449952dc9c010f"
    sha256 cellar: :any,                 arm64_monterey: "d884e7bf11b0d3e244f366df9bcad4e9f0e8762156210d3551b1e17fcbf520df"
    sha256 cellar: :any,                 arm64_big_sur:  "4ea7c812d212c683d6512b46b8a6f8750d33af59f75c308b0c743437b9950789"
    sha256 cellar: :any,                 ventura:        "73982260aa085ef2ca48819fb38d66f9ddacd0dc507959b7ef6677e2eb27e7d2"
    sha256 cellar: :any,                 monterey:       "73e26833f3391f556c6ec879d9c92ee68270653e29362c3da1c95199d68491b3"
    sha256 cellar: :any,                 big_sur:        "3b0b4fe1af3936810a56346d73a750b56ab9f234e20c498ea23757691927b7f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7500590de0baa43c07f781ad5a86bfead3aed0cf0a95905d55aeab6ba96102c"
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
