class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.4.5.0.tar.gz"
  sha256 "21177a9665021a99123885cd8383116d15013b6610b4b09bcf209612423fedc5"
  license "BSD-3-Clause"
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3f8077b972b63d134364bb0969017e24fc3f6af3fe74e8742cf4c40db1380695"
    sha256 cellar: :any,                 arm64_big_sur:  "0b4267a97e7a7db34e17761bbdcc706c7135feafbd4387cb9ba40080f8653f5c"
    sha256 cellar: :any,                 monterey:       "fed9e2608578b531d333c8ca1b04014bb21afc9c1d9b4e2a4cf416a0a6fcdfca"
    sha256 cellar: :any,                 big_sur:        "07217115d24d2d09bb85e06e9eae97d0bcf1ad48a8a56422727c80c6cf900612"
    sha256 cellar: :any,                 catalina:       "25d04c499657b7dc7f9eceea8a6b07e17872dfe4170c456e0bdc72274422f9de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ab2c6de968c5c1d48ab00d2d7217f7fa3e54ee8f94745bb7e8557db03391cd5"
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
  depends_on "python@3.10"
  depends_on "webp"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    python3 = which("python3.10")
    py3ver = Language::Python.major_minor_version python3
    ENV["PYTHONPATH"] = prefix/Language::Python.site_packages(python3)

    args = %W[
      -DPython_EXECUTABLE=#{python3}
      -DPYTHON_VERSION=#{py3ver}
      -DBUILD_MISSING_FMT=OFF
      -DCCACHE_FOUND=
      -DEMBEDPLUGINS=ON
      -DOIIO_BUILD_TESTS=OFF
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
    python = Formula["python@3.10"].opt_bin/"python3.10"
    assert_match version.major_minor_patch.to_s, pipe_output(python, output, 0)
  end
end
