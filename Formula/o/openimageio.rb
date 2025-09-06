class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.readthedocs.io/en/stable/"
  url "https://github.com/AcademySoftwareFoundation/OpenImageIO/archive/refs/tags/v3.0.10.0.tar.gz"
  sha256 "c424637af66fc6d04f202156c3f7cf4a5484ccbe07966d3d8a1fde27c7472721"
  license "Apache-2.0"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/OpenImageIO.git", branch: "main"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f2e853b06cd2229638152fe3d560be67d19981aec3791a7a8f4a86dd950a8a4c"
    sha256 cellar: :any,                 arm64_sonoma:  "0235a03c355da0d577dfe3f21450af5d410bd54fdfde88e668bfed0bce1db850"
    sha256 cellar: :any,                 arm64_ventura: "252bc775e32164d06ce9de917c94269fdfa68476098a3d867956a1ea89942011"
    sha256 cellar: :any,                 sonoma:        "77a86bf3cf6fbf81b9143dd05369ca7e02380489c496ceaae12bc3cc431e908d"
    sha256 cellar: :any,                 ventura:       "069be5bf60b5fe9b2e7ece4a91acf4c3d38aa7978d2d23007160431c06484366"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ce1b3455ebb3a0aebd4ba76b655d9bb069a56d5a6ec64f89bf12eb334f2fb36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d781bb61627f8cbf003c178700e124f1b131e0f175e720d76afc78ddba270ead"
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
