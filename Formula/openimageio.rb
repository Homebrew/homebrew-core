class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.3.11.0.tar.gz"
  sha256 "ac43f89d08cdb9661813f9fb809ccb59c211f3913f75d77db5c78e986980f9a4"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5619427e1f0b32b03951640a59ae020b06250656d62f0559cd27c019d89299bc"
    sha256 cellar: :any,                 arm64_big_sur:  "a6cc822a526c04682a3d4c85817ac08a008b9f3c4c7cea97eb68eb4c1957aa93"
    sha256 cellar: :any,                 monterey:       "67a9c3ffd57c7823728310b6509b273fad9c3cdb9ee1c8b25e01cc4afbd0ec13"
    sha256 cellar: :any,                 big_sur:        "e6c1b93398a38620848bafbd19dd80efea8c8cd674c02942f71890f2bd732597"
    sha256 cellar: :any,                 catalina:       "6a4fb6ad2eea934705757bd966fd8c9c8e2467e4ac9065f66f16ca42ac48094c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d028d6f7267f8f7d91c2d4b372442eb6ce5436f8795179e1e26dfa717f937fb1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "ffmpeg@4"
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

  fails_with gcc: "5" # ffmpeg is compiled with GCC

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

    args << "-DPython_EXECUTABLE=#{py3prefix}/bin/python3"
    args << "-DPYTHON_LIBRARY=#{py3prefix}/lib/#{shared_library("libpython#{py3ver}")}"
    args << "-DPYTHON_INCLUDE_DIR=#{py3prefix}/include/python#{py3ver}"
    args << "-DPYTHON_VERSION=#{py3ver}"

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
