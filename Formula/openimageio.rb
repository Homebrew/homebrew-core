class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.4.4.1.tar.gz"
  sha256 "3e81dff415bf58f4df889ab24a26d77c19a109ace4c5d55371925b5b00491588"
  license "BSD-3-Clause"
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6bac4960801eb6b1652d5e4d471ac7fed77fc58057ee7691dfd941b5271e53e0"
    sha256 cellar: :any,                 arm64_big_sur:  "7c3d47e90ca81b0fec205ce109a0e16797229c20fab9c8a98bbbc12c04ab918b"
    sha256 cellar: :any,                 monterey:       "8dbcf59d794d18afbd644d7390c8277e6db9ee34b8ee6fc66ee0e3639f062641"
    sha256 cellar: :any,                 big_sur:        "7363380863c6a9be8dca37270796a70c16e9a14d8c5103131d6bff7b84b2c0be"
    sha256 cellar: :any,                 catalina:       "98e4fe5eb14dd5cd1a7b33c2c301c81dc5fa95aef9671050c4c08a4a5c626438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dd51c59c0dc9d3bedaab0fd9ca947c7037b501efd41e216ad58413a783923f3"
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
