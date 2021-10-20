class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/v2.3.8.0.tar.gz"
  sha256 "0b0495e7c2c5213b1c68e9fd4e89e153355b0f61b244d77c50e7999219b07f44"
  license "BSD-3-Clause"
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "d6a030f7b529b89ddd498deb88e1e1d1406d17a563c2e7d99ff00deb76965beb"
    sha256 cellar: :any,                 big_sur:       "6106b20a1492e4fc043db08ae8795cb89e255de8a12fe41388dddcd683430416"
    sha256 cellar: :any,                 catalina:      "4858e7b56cf97d842a9b85ec5b7a33f1f1ea43e87165e32f9e4ec4260ba536fd"
    sha256 cellar: :any,                 mojave:        "aebdec660f180475b714cf79dc3d973158bacd6dca29b9153b4749f72387f103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e992c7b746afacefa1cbe847bf7e85c0c08bb79c39718170deccadf290f90eb4"
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
