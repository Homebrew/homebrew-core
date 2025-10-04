class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.readthedocs.io/en/stable/"
  url "https://github.com/AcademySoftwareFoundation/OpenImageIO/archive/refs/tags/v3.1.6.2.tar.gz"
  sha256 "a1e515e6a6ea9925a70c23db21dda37f3ce2c24780a6bfedd8685fea063f698a"
  license "Apache-2.0"
  head "https://github.com/AcademySoftwareFoundation/OpenImageIO.git", branch: "main"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f4b5a1317d730100dda3bcfecebdc72111aa952f7fed9672ba9ec240a53f6ff8"
    sha256 cellar: :any,                 arm64_sequoia: "d1d8f6fa8916d05aa2f8e0f5fb698a5e8c39fcae1e4015f06f5bcb8b6c50a10d"
    sha256 cellar: :any,                 arm64_sonoma:  "41f7d01f366f0de3d0f43c967957df75741238fae672ce9ef7c462f6e5b41dd7"
    sha256 cellar: :any,                 sonoma:        "3fcbfc9b0fc879c236b23ba4ce6c676ea1ecb8aae9e578de098029225430a73c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "783af3bc1bab870abe272c3f7300516ced0700a1bb633aeb74d516f5c1fa98a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5e4c72276410a7522cf071f14eb076e98e3f31c98e7afc3daf3b025bf20b0d2"
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
