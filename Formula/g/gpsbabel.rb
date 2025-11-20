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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "55f4f88923d7cbb34b1c2223ebfa426677a1bdd85b6be4bf42b05fc687919396"
    sha256 cellar: :any,                 arm64_sequoia: "66058dc38c5902bd1a59b7bdb11493579835ce31b6dc25aa44365577c399ec32"
    sha256 cellar: :any,                 arm64_sonoma:  "72aa587f29e407f608aa159d6a9aee1e243e03f8b27617d431a4a8ae8a9128e1"
    sha256 cellar: :any,                 sonoma:        "acb1258de4988f5b763c54576a278891c9e17b2a084d39b7cb4fa9b928d392c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a41e982d6c60f6e340f94958ca05d1a013e1de3a6a89d20de5da82296a79edc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b51c2fb69789bbf16c93d0afc525c153855b67365a8a2088a62c07b5ef8f467"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "qtserialport" => :build
  depends_on "libusb"
  depends_on "qt5compat"
  depends_on "qtbase"
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
