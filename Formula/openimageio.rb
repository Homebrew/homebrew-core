class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.4.5.0.tar.gz"
  sha256 "21177a9665021a99123885cd8383116d15013b6610b4b09bcf209612423fedc5"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0a5aa7c530bbcbfc30208f8cab3a92fbc74cee9d9bc6b0dd5ff9031dcd183b3e"
    sha256 cellar: :any,                 arm64_monterey: "b108813a8f66351fb1abb359da39e3f89f10f508c2468558e8d3fa368c63f3f0"
    sha256 cellar: :any,                 arm64_big_sur:  "4b40843a5a06cbc1943dbb902777e538618abf3b404955d386c1376c92d81f9e"
    sha256 cellar: :any,                 ventura:        "cc5ef65d5de784862a1dd24351aab4b00d0e661146f4ae3257a00211ff180fe8"
    sha256 cellar: :any,                 monterey:       "9a021fa26b0bbed5f386a0829022f9a441900bb889868d36988a4db632f2a375"
    sha256 cellar: :any,                 big_sur:        "3e7f9ed4a306ae271290c842de00f470de36f3dbac8d464d4a54e6cd0ca86146"
    sha256 cellar: :any,                 catalina:       "d0a98bdabe52ab30e3a7cd532752bfbc63ee6c4babdb0ee081788694372b2e23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d59883b7a2e945c0c5b5cc22b0ff6d2eaf1f8d3ea66e07e696f7712b6367f61"
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
