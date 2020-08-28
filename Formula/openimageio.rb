class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/Release-2.1.18.1.tar.gz"
  version "2.1.18"
  sha256 "e2cf54f5b28e18fc88e76e1703f2e39bf144c88378334527e4a1246974659a85"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/OpenImageIO/oiio.git"

  livecheck do
    url "https://github.com/OpenImageIO/oiio/releases/latest"
    regex(%r{href=.*?/tag/Release[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 "38683156e032d0dd6314399ebcc1ad4b59135e6b221f39fef74fd027fc040990" => :catalina
    sha256 "e2b1b3d5ca05a0a8cd87675a046e2b9ff25f3096b8c1fd736a1b5431dd6c1be8" => :mojave
    sha256 "e709bacc08751c67528daab022bd76ba32fdb20a061e4a8d509bc75997af13f7" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "giflib"
  depends_on "ilmbase"
  depends_on "jpeg"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "libtiff"
  depends_on "opencolorio"
  depends_on "openexr"
  depends_on "python@3.8"
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

    # CMake picks up the system's python dylib, even if we have a brewed one.
    py3ver = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    py3prefix = Formula["python@3.8"].opt_frameworks/"Python.framework/Versions/#{py3ver}"

    ENV["PYTHONPATH"] = lib/"python#{py3ver}/site-packages"

    args << "-DPYTHON_EXECUTABLE=#{py3prefix}/bin/python3"
    args << "-DPYTHON_LIBRARY=#{py3prefix}/lib/libpython#{py3ver}.dylib"
    args << "-DPYTHON_INCLUDE_DIR=#{py3prefix}/include/python#{py3ver}"

    # CMake picks up boost-python instead of boost-python3
    args << "-DBOOST_ROOT=#{Formula["boost"].opt_prefix}"
    boost_lib = Formula["boost-python3"].opt_lib
    py3ver_without_dots = py3ver.to_s.delete(".")
    args << "-DBoost_PYTHON_LIBRARIES=#{boost_lib}/libboost_python#{py3ver_without_dots}-mt.dylib"

    # This is strange, but must be set to make the hack above work
    args << "-DBoost_PYTHON_LIBRARY_DEBUG=''"
    args << "-DBoost_PYTHON_LIBRARY_RELEASE=''"

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
    assert_match version.to_s, pipe_output(Formula["python@3.8"].opt_bin/"python3", output, 0)
  end
end
