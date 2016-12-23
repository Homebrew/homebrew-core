class Gpsbabel < Formula
  desc "Converts/uploads GPS waypoints, tracks, and routes"
  homepage "https://www.gpsbabel.org/"
  url "https://github.com/gpsbabel/gpsbabel/archive/gpsbabel_1_5_3.tar.gz"
  sha256 "10b7aaca44ce557fa1175fec37297b8df55611ab2c51cb199753a22dbf2d3997"

  head "https://github.com/gpsbabel/gpsbabel.git"

  bottle do
    rebuild 1
    sha256 "15baa803be288a77a88df9425ab196bad5ba1b0725968215088f73d88e8d8270" => :sierra
    sha256 "a0e1412712d2edbe777266c0239d22b7fc086442a30da5656ca69c893426aa9b" => :el_capitan
    sha256 "01d058073e25163cd7bb89e90bd8e6890eaedf778a0f7a3f12c8b74c68ff125f" => :yosemite
  end

  depends_on "libusb" => :optional
  depends_on "qt5"

  def install
    ENV.cxx11
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--without-libusb" if build.without? "libusb"
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.loc").write <<-EOS.undent
      <?xml version="1.0"?>
      <loc version="1.0">
        <waypoint>
          <name id="1 Infinite Loop"><![CDATA[Apple headquarters]]></name>
          <coord lat="37.331695" lon="-122.030091"/>
        </waypoint>
      </loc>
    EOS
    system bin/"gpsbabel", "-i", "geo", "-f", "test.loc", "-o", "gpx", "-F", "test.gpx"
    assert File.exist? "test.gpx"
  end
end
