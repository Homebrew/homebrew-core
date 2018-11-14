class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "http://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/Release-1.8.13.tar.gz"
  sha256 "24b93ebe6cc31aa92d3246b65ec66fcf626af32fcd4b04847c7f23c8e2adcabd"
  revision 1
  head "https://github.com/OpenImageIO/oiio.git"

  bottle do
    sha256 "f59162a7c6f6c4829e3da8e0554a1a189e897773f91b0f4b2f630eaa30100506" => :mojave
    sha256 "2bf5e20b234669bd20d7e271504767232f3fe66fbb9b59d5cf798a30574e0406" => :high_sierra
    sha256 "52fee9d314dd098a1d8c64b8ded4a1908391297588b01f008eda25f0a67c5a49" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python"
  depends_on "boost-python3"
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "giflib"
  depends_on "ilmbase"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "libtiff"
  depends_on "opencolorio"
  depends_on "openexr"
  depends_on "python"
  depends_on "webp"

  def install
    # -DUSE_OPENSSL=OFF can be removed in 1.9, see
    # https://github.com/Homebrew/homebrew-core/pull/22522#issuecomment-364831533
    args = std_cmake_args + %w[
      -DEMBEDPLUGINS=ON
      -DUSE_FIELD3D=OFF
      -DUSE_JPEGTURBO=OFF
      -DUSE_NUKE=OFF
      -DUSE_OPENCV=OFF
      -DUSE_OPENGL=OFF
      -DUSE_OPENJPEG=OFF
      -DUSE_OPENSSL=OFF
      -DUSE_PTEX=OFF
      -DUSE_QT=OFF
    ]

    mkdir "build-with-python2" do
      system "cmake", "..", "-DBoost_PYTHON_LIBRARIES=#{Formula["boost-python"].opt_lib}/libboost_python27-mt.dylib",
                            *args
      system "make", "install"
    end

    # CMake picks up the system's python dylib, even if we have a brewed one.
    py3ver = Language::Python.major_minor_version "python3"
    py3prefix = Formula["python3"].opt_frameworks/"Python.framework/Versions/#{py3ver}"

    ENV["PYTHONPATH"] = lib/"python#{py3ver}/site-packages"

    args << "-DPYTHON_EXECUTABLE=#{py3prefix}/bin/python3"
    args << "-DPYTHON_LIBRARY=#{py3prefix}/lib/libpython#{py3ver}.dylib"
    args << "-DPYTHON_INCLUDE_DIR=#{py3prefix}/include/python#{py3ver}m"

    # CMake picks up boost-python instead of boost-python3
    args << "-DBOOST_ROOT=#{Formula["boost"].opt_prefix}"
    args << "-DBoost_PYTHON_LIBRARIES=#{Formula["boost-python3"].opt_lib}/libboost_python#{py3ver.to_s.delete(".")}-mt.dylib"

    # This is strange, but must be set to make the hack above work
    args << "-DBoost_PYTHON_LIBRARY_DEBUG=''"
    args << "-DBoost_PYTHON_LIBRARY_RELEASE=''"

    # Need to make a second build dir, otherwise cmake picks up cached files
    # and builds against `boost-python`
    mkdir "build-with-python3" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match "#{test_image} :    1 x    1, 3 channel, uint8 jpeg",
                 shell_output("#{bin}/oiiotool --info #{test_image} 2>&1")

    ["python", "python3"].each do |python|
      output = <<~EOS
        from __future__ import print_function
        import OpenImageIO
        print(OpenImageIO.VERSION_STRING)
      EOS
      assert_match version.to_s, pipe_output(python, output, 0)
    end
  end
end
