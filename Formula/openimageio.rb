class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.4.6.0.tar.gz"
  sha256 "a220e2bc56812b946f7ecc22dd8139b8101b51ea97522deed84a1bb6928f51dc"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0025dcdc267724a513cb3c2712348468ab6a546aa8486b77b67c5ec6c32889fd"
    sha256 cellar: :any,                 arm64_monterey: "519c54c3640765e8aa60e38cc6074b6ad884df4cf7d82ae64e84a843d3a0f86b"
    sha256 cellar: :any,                 arm64_big_sur:  "321b6694bb20f34c0f8d4b22885b1a8e6b4d6acf8f94a9db938a35b3daa39282"
    sha256 cellar: :any,                 ventura:        "05cd19f9b0585566ea8e6204fdd31fdfd861fbf81dc0dc75da647edb430f38c6"
    sha256 cellar: :any,                 monterey:       "799f80dad61ace8e5d804f4c2e49a3abc93951266b9764ee5224413ef5ecaf5d"
    sha256 cellar: :any,                 big_sur:        "bf6171826deda44c35b8242760fdb02e30b80577b251f0631a2cb5dc38456dfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "447bb203dd3fe705dfd732104363c4430676b92770d5db1fdfceb4814b0d0eba"
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
  depends_on "python@3.11"
  depends_on "webp"

  # https://github.com/OpenImageIO/oiio/blob/master/INSTALL.md
  fails_with :gcc do
    version "5"
    cause "Requires GCC 6.1 or later"
  end

  def python3
    "python3.11"
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
