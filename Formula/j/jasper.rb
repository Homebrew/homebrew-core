class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://ece.engr.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/releases/download/version-4.2.5/jasper-4.2.5.tar.gz"
  sha256 "6e49075b47204a9879600f85628a248cdb19abc1bb74d0b7a2177bcdb87c95eb"
  license "JasPer-2.0"

  livecheck do
    url :stable
    regex(/^version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5bf7fb8303c35cca02e48faa33254cc9d65306985bd4186d8141dc61bf3b643f"
    sha256 cellar: :any,                 arm64_sonoma:  "466fe76a53eec75539fd035ff2f360ce80c1996eab9a3e0fb5d376e27c8b2248"
    sha256 cellar: :any,                 arm64_ventura: "237c33c5a1af11e1944a0a23ec034e00796abec9fb1abd95fca207028d17b2ba"
    sha256 cellar: :any,                 sonoma:        "ba6b449339961161ac625af3590a931be960f4c2275d5cb37fbdef2b87ff37bc"
    sha256 cellar: :any,                 ventura:       "708052ec8c1dbc2af569e6598cd15be3c3ee591883fd32ab83d81f454a220b06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f4941da41b0df9cb13644bcf1ae1743d8f322fa981909c4424e1671349513a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6a0215c5f685c113b3920ff802d935d0a6a1853bb1f859e058421dcac0f4d2f"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"

  def install
    mkdir "tmp_cmake" do
      args = std_cmake_args
      args << "-DJAS_ENABLE_DOC=OFF"

      if OS.mac?
        # Make sure macOS's GLUT.framework is used, not XQuartz or freeglut
        # Reported to CMake upstream 4 Apr 2016 https://gitlab.kitware.com/cmake/cmake/issues/16045
        glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
        args << "-DGLUT_glut_LIBRARY=#{glut_lib}"
      else
        args << "-DJAS_ENABLE_OPENGL=OFF"
      end

      system "cmake", "..",
        "-DJAS_ENABLE_AUTOMATIC_DEPENDENCIES=false",
        "-DJAS_ENABLE_SHARED=ON",
        *args
      system "make"
      system "make", "install"
      system "make", "clean"

      system "cmake", "..",
        "-DJAS_ENABLE_SHARED=OFF",
        *args
      system "make"
      lib.install "src/libjasper/libjasper.a"
    end

    # Avoid rebuilding dependents that hard-code the prefix.
    inreplace lib/"pkgconfig/jasper.pc", prefix, opt_prefix
  end

  test do
    system bin/"jasper", "--input", test_fixtures("test.jpg"),
                         "--output", "test.bmp"
    assert_path_exists testpath/"test.bmp"
  end
end
