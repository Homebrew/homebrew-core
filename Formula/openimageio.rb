class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.3.17.0.tar.gz"
  sha256 "22d38347b40659d218fcafcadc9258d3f6eda0be02029b11969361c9a6fa9f5c"
  license "BSD-3-Clause"
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e4ab5a93af316f8b71262d58522c3bf9f4e13b9b34735e59e5d8e0a52bb5eb81"
    sha256 cellar: :any,                 arm64_big_sur:  "930987737e6316435ab93b5f0f6594dbbc79ef230fb24a9b2d6d4cd10a274ccf"
    sha256 cellar: :any,                 monterey:       "9cc9b30d6d94a7e003dc14ee8ccd1310d5d85caab06af1b874a90188d42dd1b9"
    sha256 cellar: :any,                 big_sur:        "47880e63db906b467de7adca1562b83462325ad92fbd658cd9986180e276278b"
    sha256 cellar: :any,                 catalina:       "1d6a1cc9247e9e0e25621b51fbb538e19425d381e66d760f38d2e5213d141039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb6d765a02dda93f87ef53ca20b986613bdb2bfc7ab18d672adfccea1c48d8c9"
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
