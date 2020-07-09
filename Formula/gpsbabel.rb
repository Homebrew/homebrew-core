class Gpsbabel < Formula
  desc "Converts/uploads GPS waypoints, tracks, and routes"
  homepage "https://www.gpsbabel.org/"
  url "https://github.com/gpsbabel/gpsbabel/archive/gpsbabel_1_7_0.tar.gz"
  sha256 "30b186631fb43db576b8177385ed5c31a5a15c02a6bc07bae1e0d7af9058a797"
  license "GPL-2.0"

  bottle do
    sha256 "685947e84880f27a16a442c10456990f9ede1efa8adf723fa217ba7ac5123ff7" => :catalina
    sha256 "0d5fa17f760e4ff0ebf88bf4b461c1fba6498278edd57ab77caee7576f5c4609" => :mojave
    sha256 "e147b5217a57fdf32a8073f53718e6423f227e967f9d495cb3a0bc38b5e2ad3a" => :high_sierra
    sha256 "e982a298816049c9094762699799f238cfc8d7804cf5d72f6816ebd0e8aa414e" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "qt"
  depends_on "shapelib"

  uses_from_macos "zlib"

  # upstream PR 611 added support for configuration of third party libraries.
  patch do
    url "https://github.com/gpsbabel/gpsbabel/pull/611.patch?full_index=1"
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
