class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.readthedocs.io/en/stable/"
  url "https://github.com/AcademySoftwareFoundation/OpenImageIO/archive/refs/tags/v3.2.2.0.tar.gz"
  sha256 "fa94876cfbd4c817deaba81ced8bad4af2956689faf4085f277b20197cd70b4e"
  license "Apache-2.0"
  revision 1
  compatibility_version 1
  head "https://github.com/AcademySoftwareFoundation/OpenImageIO.git", branch: "main"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "39a93aff673496178878499900c4b864e03764b56fc1c19b55b0a7250fe97bf6"
    sha256 cellar: :any, arm64_tahoe:       "238db57652eb3b2d4d492d8ab8fc9372179af22a62e5c9e4197393952a645acb"
    sha256 cellar: :any, arm64_sequoia:     "5763b5ab567eddd7e6264eefd0478ef0b43593b83657422b20fca731fa5c2414"
    sha256 cellar: :any, arm64_linux:       "0697f7a17d188ba17119744938deb80e0293dc7bb1d137c0de153f7eb9f95798"
    sha256 cellar: :any, x86_64_linux:      "799e9a45ae22b822fcacef3287711ccfc03fa275b122dad3789a6261562f32aa"
  end

  depends_on "cmake" => :build
  depends_on "nanobind" => :build
  depends_on "pkgconf" => :build
  depends_on "robin-map" => :build
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
  depends_on "python@3.15"
  depends_on "tbb"
  depends_on "webp"
  depends_on "zlib-ng-compat"

  # https://github.com/AcademySoftwareFoundation/OpenImageIO/blob/main/INSTALL.md
  fails_with :gcc do
    version "8"
    cause "Requires GCC 9.3 or later"
  end

  deny_network_access!

  def install
    py3ver = Language::Python.major_minor_version python3
    ENV["PYTHONPATH"] = site_packages = prefix/Language::Python.site_packages(python3)

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: site_packages/"OpenImageIO")}
      -DPython3_EXECUTABLE=#{python3}
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
