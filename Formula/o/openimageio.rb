class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.readthedocs.io/en/stable/"
  url "https://github.com/AcademySoftwareFoundation/OpenImageIO/archive/refs/tags/v2.5.12.0.tar.gz"
  sha256 "51ea3c309bad7381fd0d7ef793e93a72d8e0edaeff4ff329f4f21fb5de3d90bd"
  license "Apache-2.0"
  head "https://github.com/AcademySoftwareFoundation/OpenImageIO.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3a541b2d9ccfde8bdce78b9323c915510114d582d79b33baca1647ce0b30f603"
    sha256 cellar: :any,                 arm64_ventura:  "300f8000799caf49595e36d1c71222f575243c4aca31c274d2dfbdfba4647d0b"
    sha256 cellar: :any,                 arm64_monterey: "9c09c449d5a75d6df69c3ba995f0ccf70ad8d3649e95bcaa456be191b3c84e31"
    sha256 cellar: :any,                 sonoma:         "7a5ec5548930109b537d45476c48384b69cb209af8d1d83b479e4e8d646cf73d"
    sha256 cellar: :any,                 ventura:        "567a9d6b56eedb0a3dea38af132fb40987ae6b0d4ff34ed64afd9e105630e586"
    sha256 cellar: :any,                 monterey:       "f8252aef7b25fd2523f9a98921890ef2a6fc1e4c4710419687de4c32c29b4236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9b6045bfd6d9736cda467d865c5dbba24b014d5cd2e3b58fb73aca5021692c1"
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
  depends_on "tbb"
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
