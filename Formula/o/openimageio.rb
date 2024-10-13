class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.readthedocs.io/en/stable/"
  url "https://github.com/AcademySoftwareFoundation/OpenImageIO/archive/refs/tags/v2.5.16.0.tar.gz"
  sha256 "e5438e28d34a5b0a09428ed77ec310edd47c141db1b259364859110847e161e7"
  license "Apache-2.0"
  revision 2
  head "https://github.com/AcademySoftwareFoundation/OpenImageIO.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e4745e282ce38a19c4bc7183cceaf43e5375759a4c57d47a69b15225ee640a63"
    sha256 cellar: :any,                 arm64_sonoma:  "506fa226e7dced0a7eb35a00bb2c9d63d2a35bf204ec294f02654cac0afe5bc4"
    sha256 cellar: :any,                 arm64_ventura: "152f273dbdb00eb8bf0aee21c0b5d6e77262d0bdbffaf47491be3b90e54cc521"
    sha256 cellar: :any,                 sonoma:        "d1cf558ffe0aa1e9b624fe5074431d2058cb0409238d5b2e24eb6d477f348e8d"
    sha256 cellar: :any,                 ventura:       "fbd2811178a38c55e306d5985ff87a3fe9ed7785703274fde545cd7b39214a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd3a2ee00a6e2a17dace308cf0f471a00c1b877c590021d7d9db337e82f248ca"
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

  uses_from_macos "zlib"

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
