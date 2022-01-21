class Gpsbabel < Formula
  desc "Converts/uploads GPS waypoints, tracks, and routes"
  homepage "https://www.gpsbabel.org/"
  url "https://github.com/GPSBabel/gpsbabel/archive/gpsbabel_1_8_0.tar.gz"
  sha256 "448379f0bf5f5e4514ed9ca8a1069b132f4d0e2ab350e2277e0166bf126b0832"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^gpsbabel[._-]v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5357d3b45f387798979f3cedc684fbcc67cff808472d08c5c0af62923e96d5ef"
    sha256 cellar: :any,                 arm64_big_sur:  "c7ee4482d5aec2eb9c2a13012fc9ca66f9ffdd8d81350a2a89594ed99d27175c"
    sha256                               big_sur:        "6d5c179704f46781438a06f02a6e83c0d9e5bfa3af0f15b738af0029a4cc56af"
    sha256                               catalina:       "c71c3f2662684e9c03cac17d2f211b58ee07b3dc64ce74121922cca41d6b303c"
    sha256                               mojave:         "0a8e9cb2650be7396304d7486975e4ef82dce6e1890f8f54cbbaa0e05ab99991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9b4de5bfef2c0548e1de3c4b5d82e881b511d7ea2bd496fe645a5373c5ef354"
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "qt"
  depends_on "shapelib"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11
    # force use of homebrew libusb-1.0 instead of included version.
    # force use of homebrew shapelib instead of included version.
    # force use of system zlib instead of included version.
    rm_r "mac/libusb"
    rm_r "shapelib"
    rm_r "zlib"
    shapelib = Formula["shapelib"]
    system "qmake", "GPSBabel.pro",
           "WITH_LIBUSB=pkgconfig",
           "WITH_SHAPELIB=custom", "INCLUDEPATH+=#{shapelib.opt_include}", "LIBS+=-L#{shapelib.opt_lib} -lshp",
           "WITH_ZLIB=pkgconfig"
    system "make"
    bin.install "gpsbabel"
  end

  test do
    (testpath/"test.loc").write <<~EOS
      <?xml version="1.0"?>
      <loc version="1.0">
        <waypoint>
          <name id="1 Infinite Loop"><![CDATA[Apple headquarters]]></name>
          <coord lat="37.331695" lon="-122.030091"/>
        </waypoint>
      </loc>
    EOS
    system bin/"gpsbabel", "-i", "geo", "-f", "test.loc", "-o", "gpx", "-F", "test.gpx"
    assert_predicate testpath/"test.gpx", :exist?
  end
end
