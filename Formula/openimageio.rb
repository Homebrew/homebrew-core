class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.3.9.1.tar.gz"
  sha256 "59d3bc8dabc8ac99e2d94461b9f87554049a187f0e48e65b2775e37bb9175870"
  license "BSD-3-Clause"
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "e7a6785e5033dd03bcaea161461c1ddc2c924be7bdc87eeefd4f3663b562850b"
    sha256 cellar: :any,                 monterey:      "081a46743a87cdb38043f03ff5b778211f83f9103176410a99214f20495aab83"
    sha256 cellar: :any,                 big_sur:       "be5d194fae37392924010b6e5afa6679d41964793444889f79de2be4dd510e02"
    sha256 cellar: :any,                 catalina:      "51057af945d413ef22522150d18ba9c3dede9f20d9920c86e1dbdc5e6f3ac6b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3175d437afc73ca5df30e2fe3ab06e56b55d3bc7c8ea081ebc32d430563ac573"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "giflib"
  depends_on "imath"
  depends_on "jpeg"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "libtiff"
  depends_on "opencolorio"
  depends_on "openexr"
  depends_on "pybind11"
  depends_on "python@3.9"
  depends_on "webp"

  def install
    args = std_cmake_args + %w[
      -DCCACHE_FOUND=
      -DEMBEDPLUGINS=ON
      -DUSE_FIELD3D=OFF
      -DUSE_JPEGTURBO=OFF
      -DUSE_NUKE=OFF
      -DUSE_OPENCV=OFF
      -DUSE_OPENGL=OFF
      -DUSE_OPENJPEG=OFF
      -DUSE_PTEX=OFF
      -DUSE_QT=OFF
    ]

    # CMake picks up the system's python shared library, even if we have a brewed one.
    py3ver = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    py3prefix = if OS.mac?
      Formula["python@3.9"].opt_frameworks/"Python.framework/Versions/#{py3ver}"
    else
      Formula["python@3.9"].opt_prefix
    end

    ENV["PYTHONPATH"] = lib/"python#{py3ver}/site-packages"

    args << "-DPYTHON_EXECUTABLE=#{py3prefix}/bin/python3"
    args << "-DPYTHON_LIBRARY=#{py3prefix}/lib/#{shared_library("libpython#{py3ver}")}"
    args << "-DPYTHON_INCLUDE_DIR=#{py3prefix}/include/python#{py3ver}"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
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
    assert_match version.major_minor_patch.to_s, pipe_output(Formula["python@3.9"].opt_bin/"python3", output, 0)
  end
end
