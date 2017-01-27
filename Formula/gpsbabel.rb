class Gpsbabel < Formula
  desc "Converts/uploads GPS waypoints, tracks, and routes"
  homepage "https://www.gpsbabel.org/"
  url "https://github.com/gpsbabel/gpsbabel/archive/gpsbabel_1_5_3.tar.gz"
  sha256 "10b7aaca44ce557fa1175fec37297b8df55611ab2c51cb199753a22dbf2d3997"
  revision 1
  head "https://github.com/gpsbabel/gpsbabel.git"

  bottle do
    sha256 "c685966fc38fa1eebbf825fa1bf24384980449a3151e8d02555eb7cb3c2f5d05" => :sierra
    sha256 "c04cd7036a76376bbaa7bacdd74c72c4974945ca7747d9b2edf6f89166eb459e" => :el_capitan
    sha256 "ce0c38b489ed3d1b6d00f09dfbd2170848daf102ab5e0af26ebee05549fc13a6" => :yosemite
  end

  depends_on "libusb" => :optional
  depends_on "qt@5.7"

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
