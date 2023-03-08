class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.4.9.0.tar.gz"
  sha256 "d04c12575d63d13ed64fc037ea37da616224736213d785de9f50337f6eb5a9ed"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d8b2ef86400941388ea0d25bf266239733a82fb6bdecf715a42a4c3c2cdc2c31"
    sha256 cellar: :any,                 arm64_monterey: "698775daaf34d714e76deee1dc0e7241ab48ccdb704b6f878ea6787e8e7283a3"
    sha256 cellar: :any,                 arm64_big_sur:  "aae2b9cc8451df5b9efe8cdde1c5f2e65f2360a51a91e0109c10c52ae84b9c7e"
    sha256 cellar: :any,                 ventura:        "2d9b9ae33c5418ee299c241f52124dc0d73d79a480ab3c5c54b2192d084007a2"
    sha256 cellar: :any,                 monterey:       "1334cbd6ab68820325e4b2bae183c50a18117147f5a2d5b65bb8a5ce7ec371a3"
    sha256 cellar: :any,                 big_sur:        "82f2679ec05f6c3fb118602dae305b3fecb335f01c51f66a1728129a8a784e68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4fa9e61656096e3a330a0c795663fed6d8f07a76f5170b336695ad419cf8cf8"
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
      -DUSE_DCMTK=OFF
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
