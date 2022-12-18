class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.4.6.0.tar.gz"
  sha256 "a220e2bc56812b946f7ecc22dd8139b8101b51ea97522deed84a1bb6928f51dc"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a5756f625d8a5f6adeaa705fa6a9b2e68facd193fa8d21c623977529c0b70beb"
    sha256 cellar: :any,                 arm64_monterey: "dca55614fe46349d7cf2c3719878c68067813ea2ec69ee3a70737ecc19e81960"
    sha256 cellar: :any,                 arm64_big_sur:  "2be5d427f3040d9ab1adbc8fd3e51761882ade7838c4228af7defd100fbf6964"
    sha256 cellar: :any,                 ventura:        "6636ead7e419c30afc427bfd7bfb2458d8427c61b1ad49ba3174c2e844f1b581"
    sha256 cellar: :any,                 monterey:       "e1757aa7124a8a8735acf60c43c02d754457ab80f0a1b59f52fa27a9688cdd19"
    sha256 cellar: :any,                 big_sur:        "cd459ebdaeb096e41bac4e0487050731f123f68425e16c5a5cc8e2809b13b114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47d5d90b7153c18dfa9cf32fcc62e1bfe93cbdb0f7bb8954067b115272b9b58a"
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
