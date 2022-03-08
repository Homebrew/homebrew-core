class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.3.13.0.tar.gz"
  sha256 "78f5754f1a9eb8215d66ca62a2963b87fc2b91465cb181dfc4ef73ca3ed76adb"
  license "BSD-3-Clause"
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1cada03936195ee5c87bda75a831552abb87ee22b87b3c12688d33567f8c0e54"
    sha256 cellar: :any,                 arm64_big_sur:  "59f378143b26ec6deadd206127e522081946f7b03995aa1cbe0591869ebaf250"
    sha256 cellar: :any,                 monterey:       "eebd0137086a11245af0fee88a3f40ef1a88ac24c5c6ff756d21119fe6625068"
    sha256 cellar: :any,                 big_sur:        "d3c67616c57846658a13533f9c14fdcdf45f5b1a6bce09d6748fd7f733e97a77"
    sha256 cellar: :any,                 catalina:       "80155b89cfd466570443fc1088a8afb51e146c98130f10b82a5fd46b9e2a100b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "134fd1a7eb321bb299fea90ff322a49d666fec038fd80a7e472f125599b3406a"
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
