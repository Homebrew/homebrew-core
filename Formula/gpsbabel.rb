class Gpsbabel < Formula
  desc "Converts/uploads GPS waypoints, tracks, and routes"
  homepage "https://www.gpsbabel.org/"
  url "https://github.com/gpsbabel/gpsbabel/archive/gpsbabel_1_7_0.tar.gz"
  sha256 "30b186631fb43db576b8177385ed5c31a5a15c02a6bc07bae1e0d7af9058a797"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(/^gpsbabel[._-]v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 "1527cf246d7bc4c9ad4ea32f1dae2df36a34c2f10e1a561474a52e40fd455114" => :big_sur
    sha256 "ef08f246d1d7321d1bb605591194f2d207fc0cd2465755dbbe86afc640cb41db" => :catalina
    sha256 "7a622c1a689d239e3a98185220428127cffee6f3d060519d509106a8a37fdbc1" => :mojave
    sha256 "d8a8ecec7300d96476fbba89a2343d87712628cfd2f4325df19aed2dabec4b17" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "qt"
  depends_on "shapelib"

  uses_from_macos "zlib"

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
