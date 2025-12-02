class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.readthedocs.io/en/stable/"
  url "https://github.com/AcademySoftwareFoundation/OpenImageIO/archive/refs/tags/v3.1.8.0.tar.gz"
  sha256 "6749eeb89f8b8b8c61261801149a3863d352ff17980933c58199293ef2310816"
  license "Apache-2.0"
  head "https://github.com/AcademySoftwareFoundation/OpenImageIO.git", branch: "main"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9fb0717b14f22862d64e94499d08d91f7074c2b2f9d95b8b4d235ef9f5d77666"
    sha256 cellar: :any,                 arm64_sequoia: "9b01013f3c36a08bb01c4867b00f6a723cea9db812d2a6fcf1c1f9f5464f3c09"
    sha256 cellar: :any,                 arm64_sonoma:  "fd1fded8c0743a9b6559800e2a41cc1526a9164b36f2ba186eda6aee3480f79c"
    sha256 cellar: :any,                 sonoma:        "f7b80152f466454807890fbb8a13cb436157598ade66c827dece6c6753613117"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a2c4783296b9264aee7a82620705c7b8fa4012a9dde106593843670e83f63be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ee6334330a650502fad5af91fb009ca664f1d1d5d85228b318cc40b0e9fd3c5"
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
  depends_on "python@3.14"
  depends_on "tbb"
  depends_on "webp"
  depends_on "zlib"

  # https://github.com/AcademySoftwareFoundation/OpenImageIO/blob/main/INSTALL.md
  fails_with :gcc do
    version "8"
    cause "Requires GCC 9.3 or later"
  end

  def python3
    "python3.14"
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
