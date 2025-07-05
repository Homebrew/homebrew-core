class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.readthedocs.io/en/stable/"
  url "https://github.com/AcademySoftwareFoundation/OpenImageIO/archive/refs/tags/v3.0.8.1.tar.gz"
  sha256 "1b9b0d27e802243c1aa490b951580d10e8be645459f8080bfa0ed6f213e1082a"
  license "Apache-2.0"
  head "https://github.com/AcademySoftwareFoundation/OpenImageIO.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6540937491421442a78c308aa740e0092740b566cbf3e281a05515ba66f566b4"
    sha256 cellar: :any,                 arm64_sonoma:  "b213b7b0c01e9e60603802687e1a759a053da2363856c3a5a01d7c2e1d4c5954"
    sha256 cellar: :any,                 arm64_ventura: "fa0e256256d86b154fbb2c98f867079817ad0ff6b86a5ded469b5c00c0719568"
    sha256 cellar: :any,                 sonoma:        "6a3a50bc40af258103d458dc04a709f6de1475700decf9bce4770a9f0dca89e1"
    sha256 cellar: :any,                 ventura:       "93dc0aa11f2f5193638771a35740fd03d4084d4d4ab160d80d42cc9bee64439c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "039219e09b80b9b26dec743ed8ab5c81f30bf340c73d62b5a91224f446ed3b1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6c108717065b9324bf94de2de11e5740994c60edbba574c5e2b9eda9a1e1037"
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

  # libheif 1.19+ build patch, upstream pr ref, https://github.com/AcademySoftwareFoundation/OpenImageIO/pull/4822
  patch do
    url "https://github.com/AcademySoftwareFoundation/OpenImageIO/commit/beed875f983c2b80a61c32be1d22d08f5be725bd.patch?full_index=1"
    sha256 "f4f6509c7e1dd7a196eed4545d4c52341d629502c8d88719ff25da35d8eff622"
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
