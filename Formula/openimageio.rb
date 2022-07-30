class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.3.17.0.tar.gz"
  sha256 "22d38347b40659d218fcafcadc9258d3f6eda0be02029b11969361c9a6fa9f5c"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "72cab7a5f6afdcd23d3e01cc13af701589fded2d53d6c67c4c052e2102a568ef"
    sha256 cellar: :any,                 arm64_big_sur:  "caa4da692e13ed13d69a05ec2c6ae76b7abd94d3b1f286f2daa1054fbc567c27"
    sha256 cellar: :any,                 monterey:       "bd0df70d2c235361f413e5d90a5ed066fd653366e62abbeb9894fb09fa6db834"
    sha256 cellar: :any,                 big_sur:        "a8758a87846c43e2141bd43ece5724f73a4a949d56d2dd1ed427c3e6d66ff4fb"
    sha256 cellar: :any,                 catalina:       "2311002fe954ee837137c6c7180996a12764fe3735748f779d26ef64ba5487ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba8d77a87e64bf0b842ed1ef8b15673f25741c1b417da69f786662b3207be32a"
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
      -DUSE_JPEGTURBO=OFF
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
