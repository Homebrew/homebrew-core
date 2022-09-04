class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  license "BSD-3-Clause"
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  stable do
    url "https://github.com/OpenImageIO/oiio/archive/v2.3.19.0.tar.gz"
    sha256 "602c146aebee775f123459a6c6be753054144b8d82777de26965f2cc3e88113a"

    # Upstream changes to cleanly apply subsequent PR commit. Remove in the next release.
    patch do
      url "https://github.com/OpenImageIO/oiio/commit/c3740921b6fd09a0769bd403dab99ba9061228b0.patch?full_index=1"
      sha256 "61764eb19f936f3ced3b23d1b6a27b7aad4f38ccfd52f6591c354b6f4ebcadf6"
    end

    # Fix CMake detection of FFmpeg 5.1+. Remove after PR is merged and in a release.
    # PR ref: https://github.com/OpenImageIO/oiio/pull/3516
    patch do
      url "https://github.com/OpenImageIO/oiio/commit/a86911a3e0bc5b2406856428295938d960760368.patch?full_index=1"
      sha256 "e38a50b98dbab81bd50a460a87aa3970f25a49959796c01db6888a0e62e3af62"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "936686a8355b5528dd3f88f3a743caaf10b74fc694eebf5f7e084b1973ca4c15"
    sha256 cellar: :any,                 arm64_big_sur:  "08062516cf0fb2f22c041aa610fc20463523047bd81959f6ac51df5841d6dce5"
    sha256 cellar: :any,                 monterey:       "fbd9ffd6259b167948889cb11668cf337611c56d9da411093e31698bba0f4572"
    sha256 cellar: :any,                 big_sur:        "e0dcfcb5d45ed55098d74568b545a67436cb1f0b58e2827a0c0e8062336edb3c"
    sha256 cellar: :any,                 catalina:       "43ecd261d74452af7199ca3e4fd94bfa50ab27b1ef65767dec636ff659a3296d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "037499f29be934e10cda76a07947b99bc6f12b9cb97e4815b935185cf540fc38"
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
