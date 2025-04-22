class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.readthedocs.io/en/stable/"
  url "https://github.com/AcademySoftwareFoundation/OpenImageIO/archive/refs/tags/v3.0.4.0.tar.gz"
  sha256 "dd481071d532c1ab38242011bb7af16f6ec7d915c58cada9fb78ed72b402ebc5"
  license "Apache-2.0"
  head "https://github.com/AcademySoftwareFoundation/OpenImageIO.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fabfcbfcd422a179aca1b2667b7fc97afbbfcb33068c24be4cf13a9d2df506d9"
    sha256 cellar: :any,                 arm64_sonoma:  "15844d3b731b19888a755b7d19605a8a2c13ea913628399265144271443710f7"
    sha256 cellar: :any,                 arm64_ventura: "62afb78dcccaedb0d0c47ebd8bb040bc3e3542c6deb3a6507e8b750bfa4ac534"
    sha256 cellar: :any,                 sonoma:        "9846a1521b2fffbf9236993ed57887ce648df52d41cec348e7ef2cc7b0b1b3f2"
    sha256 cellar: :any,                 ventura:       "34883f8bf7495f8ea40fca3d71e369f3df8a75cec938bcd7f476b266f8100c81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3409039beffcbf97455e2876503b014e803ee3d5974ce240db59cd038bc9cd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e0e791e125f44eb6f6bee02f4f070ce818e52391f78008cdc8c1561f2d833c1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "pybind11" => :build
  depends_on "ffmpeg"
  depends_on "fmt" # needed for headers
  depends_on "freetype"
  depends_on "giflib"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "libtiff"
  depends_on "opencolorio"
  depends_on "openexr"
  depends_on "pugixml"
  depends_on "python@3.13"
  depends_on "tbb"
  depends_on "webp"

  uses_from_macos "zlib"

  # https://github.com/AcademySoftwareFoundation/OpenImageIO/blob/main/INSTALL.md
  fails_with :gcc do
    version "8"
    cause "Requires GCC 9.3 or later"
  end

  def python3
    "python3.13"
  end

  def install
    py3ver = Language::Python.major_minor_version python3
    ENV["PYTHONPATH"] = site_packages = prefix/Language::Python.site_packages(python3)

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: site_packages/"OpenImageIO")}
      -DPython3_EXECUTABLE=#{which(python3)}
      -DPYTHON_VERSION=#{py3ver}
      -DCCACHE_FOUND=
      -DEMBEDPLUGINS=ON
      -DOIIO_BUILD_TESTS=OFF
      -DOIIO_INTERNALIZE_FMT=OFF
      -DUSE_DCMTK=OFF
      -DUSE_EXTERNAL_PUGIXML=ON
      -DUSE_NUKE=OFF
      -DUSE_OPENCV=OFF
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

    output = <<~PYTHON
      import OpenImageIO
      print(OpenImageIO.VERSION_STRING)
    PYTHON
    assert_match version.major_minor_patch.to_s, pipe_output(python3, output, 0)
  end
end
