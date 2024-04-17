class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.readthedocs.io/en/stable/"
  url "https://github.com/AcademySoftwareFoundation/OpenImageIO/archive/refs/tags/v2.5.10.1.tar.gz"
  sha256 "8f6a547f6a5d510737ba436f867043db537def65f0fdb14ec30e5a185b619f93"
  license "Apache-2.0"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/OpenImageIO.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "02bc654628c6b9d528b8bf30263e4cccf0570ff3367714f34e1dda936c7afdc7"
    sha256 cellar: :any,                 arm64_ventura:  "80f325a348f4504326d81703adb0c9f9f5820668be75059b43be947e0dce2e1a"
    sha256 cellar: :any,                 arm64_monterey: "9bee89d81a5a6b396f9afb072c633a4e3b228c49cac4b56a2cf257d2e6c1a633"
    sha256 cellar: :any,                 sonoma:         "d34958217dfeff5c93e476bb74758038a8c7cbcc4346c4f8904bc3736481c19e"
    sha256 cellar: :any,                 ventura:        "6c4525071137481b369d09cb0c9c036793ede80b31b5bbf69b1111f79d8051bb"
    sha256 cellar: :any,                 monterey:       "01ed16dd7e5ec44636bd8cba6721725f35a6e519b30f9edd77c98f40336ac159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2673c7a010ef048ddf0bf0310a5f9e7e4d1bbde7ad5baa95208dcbd4e1e15e7"
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
