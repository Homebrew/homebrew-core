class Gpsbabel < Formula
  desc "Converts/uploads GPS waypoints, tracks, and routes"
  homepage "https://www.gpsbabel.org/"
  url "https://github.com/GPSBabel/gpsbabel/archive/refs/tags/gpsbabel_1_10_0.tar.gz"
  sha256 "a89756fb988a54f5c5f371413845b9aecb66628a594cd83bd529c0f18382c968"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^gpsbabel[._-]v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "2fdf2224f180cf49634c7262ae03f435dc5a6717bba6b780e8b56d3901d00ffd"
    sha256 cellar: :any,                 arm64_ventura: "f33d3021cb041af672e04d337d783eda512ac37e2f1c53eb7b86341d6f13e332"
    sha256                               sonoma:        "8018d83e557a241772517a69440b16e3367e4a20542e688de3f9f6e1452420c5"
    sha256                               ventura:       "3ccb0910e87721002a8de68f301ed95e0d0e940e9565dedcc9d2082f19275d7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e04ac4e5f6077a3636e8cfc501ee4acfb965f220b4c85008d50033156f0e18f7"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"
  depends_on "qt"
  depends_on "shapelib"

  uses_from_macos "zlib"

  def install
    ENV.cxx11
    # force use of homebrew libusb-1.0 instead of included version.
    # force use of homebrew shapelib instead of included version.
    # force use of system zlib instead of included version.
    rm_r "mac/libusb"
    rm_r "shapelib"
    rm_r "zlib"
    system "cmake", "-S", ".", "-B", "build",
                    "-DGPSBABEL_WITH_LIBUSB=pkgconfig",
                    "-DGPSBABEL_WITH_SHAPELIB=pkgconfig",
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
    assert_path_exists testpath/"test.gpx"
  end
end
