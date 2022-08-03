class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.3.18.0.tar.gz"
  sha256 "09c7fa0685fdb34f696f2e5d44c2ba2336b5ca6ad8851cb516575508fe06397a"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f14e3f2e421c8b2616744fe57beca11a7fc67036c6102ab6b81da8cf582f0ded"
    sha256 cellar: :any,                 arm64_big_sur:  "f0c6b95e886fa7c742449413a69baba3236bc82eb44769ba3d40d8f8219816fa"
    sha256 cellar: :any,                 monterey:       "c3bbfb8bce713e400f06077c4b89311948c8639d21dadc1dbc91640f214ad7be"
    sha256 cellar: :any,                 big_sur:        "4ede7ddcd60c8375f09dea34f0508bfa7e2b3f19f97d7b797c7a1949a684962f"
    sha256 cellar: :any,                 catalina:       "afd67dcac37f305e74183aadd820873312b9c19aefd85bb01316d519165ae246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d8c1e85eac50a68df9eda734363197bedee174dff2744b10f61f9c3138fa5f2"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "ffmpeg"
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
  depends_on "pybind11"
  depends_on "python@3.10"
  depends_on "webp"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def python
    deps.map(&:to_formula)
        .find { |f| f.name.match?(/^python@\d\.\d+$/) }
  end

  def install
    args = %w[
      -DCCACHE_FOUND=
      -DEMBEDPLUGINS=ON
      -DUSE_FIELD3D=OFF
      -DUSE_JPEGTURBO=ON
      -DUSE_NUKE=OFF
      -DUSE_OPENCV=OFF
      -DUSE_OPENGL=OFF
      -DUSE_OPENJPEG=OFF
      -DUSE_PTEX=OFF
      -DUSE_QT=OFF
    ]

    # CMake picks up the system's python shared library, even if we have a brewed one.
    python3 = python.opt_bin/"python3"
    py3ver = Language::Python.major_minor_version(python3)
    py3prefix = if OS.mac?
      python.opt_frameworks/"Python.framework/Versions"/py3ver
    else
      python.opt_prefix
    end

    ENV["PYTHONPATH"] = prefix/Language::Python.site_packages(python3)

    args << "-DPython_EXECUTABLE=#{python3}"
    args << "-DPYTHON_LIBRARY=#{py3prefix}/lib/#{shared_library("libpython#{py3ver}")}"
    args << "-DPYTHON_INCLUDE_DIR=#{py3prefix}/include/python#{py3ver}"
    args << "-DPYTHON_VERSION=#{py3ver}"

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
    assert_match version.major_minor_patch.to_s, pipe_output(python.opt_bin/"python3", output, 0)
  end
end
