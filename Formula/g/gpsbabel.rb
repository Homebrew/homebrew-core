class Gpsbabel < Formula
  desc "Converts/uploads GPS waypoints, tracks, and routes"
  homepage "https://www.gpsbabel.org/"
  url "https://github.com/GPSBabel/gpsbabel/archive/refs/tags/gpsbabel_1_9_0.tar.gz"
  sha256 "7801d30553bbc25d0b0e8186f2f5a1ec41397e51a26b92cc8ad1aeaa77c9beb6"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^gpsbabel[._-]v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ad979a6934703acb06ab64021d66dd94c3a2fa3805e8878dcd755383bd881323"
    sha256 cellar: :any,                 arm64_ventura:  "40696e53a377f887e7a5e5ae3a67d5d8148bbe9e0b303299b9e9e51f22bbccb1"
    sha256 cellar: :any,                 arm64_monterey: "366f727d7d5902c15efbd064cb1143440ad215f3c6e0c1e5fde1fbcb884637c2"
    sha256                               sonoma:         "02fb44289edae0dcc93b2209be3f05654086fb403869630fb53ae22cea8a2e08"
    sha256                               ventura:        "8bfb20e244b7a35d31d1109a278e1786f980c4dbcd546d1e0624f64e5295e02d"
    sha256                               monterey:       "9703c21cee29577b79c60d074f62ac98a24710a810c20bc5bf3e15627e0940dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c8cdc10690f1eba7e5277758863341f80f628423ec5da6e78f8ea62f286cfe1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "qt"
  depends_on "shapelib"

  uses_from_macos "zlib"

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
    system "cmake", "-S", ".", "-B", "build",
                    "-DGPSBABEL_WITH_LIBUSB=pkgconfig",
                    "-DGPSBABEL_WITH_SHAPELIB=custom",
                    "-DGPSBABEL_EXTRA_INCLUDE_DIRECTORIES=#{shapelib.opt_include}",
                    "-DGPSBABEL_EXTRA_LINK_LIBRARIES=-L#{shapelib.opt_lib} -lshp",
                    "-DGPSBABEL_WITH_ZLIB=pkgconfig",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "gpsbabel"
    bin.install "build/gpsbabel"
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
