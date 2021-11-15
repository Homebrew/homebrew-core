class Gpsbabel < Formula
  desc "Converts/uploads GPS waypoints, tracks, and routes"
  homepage "https://www.gpsbabel.org/"
  url "https://github.com/gpsbabel/gpsbabel/archive/gpsbabel_1_7_0.tar.gz"
  sha256 "30b186631fb43db576b8177385ed5c31a5a15c02a6bc07bae1e0d7af9058a797"
  license "GPL-2.0-or-later"
  revision 1

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
  depends_on "qt@5"
  depends_on "shapelib"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # upstream https://github.com/gpsbabel/gpsbabel/pull/611 added support for configuration of third party libraries.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/8122e505c149fdb42132a18a9749f7b8c9940b77/gpsbabel/1.7.0.patch"
    sha256 "8f6572aa8dc3a7b4db028bf75d952d97f7b47de278a91c3cc86bebed608be86a"
  end

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
