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
    sha256 cellar: :any,                 arm64_monterey: "7b5c28ab75dade273785b1e7f7080a2067e10262462bb4e4a19da5daa0e7e64d"
    sha256 cellar: :any,                 arm64_big_sur:  "ac807500298ffee8afc0ad6d884db0307d73fb639733ae4c074c91f04ef1ba72"
    sha256                               monterey:       "8c12af303436297edaf88e0e78583d76c31032ff3477659caaeae64c134428b9"
    sha256                               big_sur:        "3e47fe71c6074f53f9ca9c25e357e6f8fb3b146bbc829dea38fae76a767e068b"
    sha256                               catalina:       "3d4f1679c62ccd105a106cd2aba55e091d1312d3b636230721f3c7c4e33f78f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e500ef423595a42e5fe19e50221d210201a7a2cd6bd556654f1a8ba66122154"
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
