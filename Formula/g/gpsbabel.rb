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

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "f5a6e165e7d310ead14a3f4eba01ea1d7367fe5feb7e0736cdbe1291e25cf9f1"
    sha256 cellar: :any,                 arm64_sequoia: "ee0edd5748373bc587c31d0d97064f2b23058e2c8cd2627ed49e5e14cbe0b23a"
    sha256 cellar: :any,                 arm64_sonoma:  "224cc493bf2f416e2f4b9da7237ec75d53a2dbdcbdb031795982747070b60ab9"
    sha256 cellar: :any,                 sonoma:        "5ccb88102bb1902e6ab6f9ff5cd275fc966be2f2b2082b0aa94ab83419f0ef9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d9644f2f53d57333345dc3b75d93d05443072654d5600d92e87cc7732b3fd3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5008e8faffe2128519d5fdd5ebfc432f74f021a3b2937763b3a0b6cb54f68ff"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "qtserialport" => :build
  depends_on "libusb"
  depends_on "qt5compat"
  depends_on "qtbase"
  depends_on "shapelib"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    (testpath/"test.loc").write <<~XML
      <?xml version="1.0"?>
      <loc version="1.0">
        <waypoint>
          <name id="1 Infinite Loop"><![CDATA[Apple headquarters]]></name>
          <coord lat="37.331695" lon="-122.030091"/>
        </waypoint>
      </loc>
    XML
    system bin/"gpsbabel", "-i", "geo", "-f", "test.loc", "-o", "gpx", "-F", "test.gpx"
    assert_path_exists testpath/"test.gpx"
  end
end
