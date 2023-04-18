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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "f2b81e2ad20e8172ae57d46d67ca75f542ccfbc260cea6cef6ff9bc9ac7829e0"
    sha256 cellar: :any,                 arm64_monterey: "646be265241a8f78c88289bef277cbe444db6a0bf7cd02e197ef395917575ca6"
    sha256 cellar: :any,                 arm64_big_sur:  "908cf83c712d6f730d3ab1a5d7b2fd8fd0ded530949016c0b6ebaaeb322d2db0"
    sha256                               ventura:        "27797000ed7e6fd54a016955bb4a359013b9e2518dc622c87250bc7bdd920b54"
    sha256                               monterey:       "1c425bf6dc9f522a59c67e37ad8d16af80e0dc334f5ab820ed12ad415907704a"
    sha256                               big_sur:        "67cd2df2db497332a254d7923ebdd9bc17450195d53f327788326f2405451c4a"
    sha256                               catalina:       "7f699fcc659b539678c725aaad769b98afd9ef25bf9071b3acc55088c46a379e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a42240e22fd5787212ff71c58030b15eddd6c362846e8dc315765cffd7437e1"
  end

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
