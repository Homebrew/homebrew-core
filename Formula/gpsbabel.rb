class Gpsbabel < Formula
  desc "Converts/uploads GPS waypoints, tracks, and routes"
  homepage "https://www.gpsbabel.org/"
  url "https://github.com/gpsbabel/gpsbabel/archive/gpsbabel_1_5_3.tar.gz"
  sha256 "10b7aaca44ce557fa1175fec37297b8df55611ab2c51cb199753a22dbf2d3997"

  head "https://github.com/gpsbabel/gpsbabel.git"

  bottle do
    sha256 "482d2be982a47456f7b625bb3ff0b22d52dc272271bae0b70f369026213f6c52" => :el_capitan
    sha256 "a0b334caed2791cffd26666d79693c7c4a368b679ac8190100f247450288a2e6" => :yosemite
    sha256 "0d24574b503eadf641ce7d67f0a57bec0dbd2264fb7fde5a3b8607e157f03829" => :mavericks
  end

  depends_on "libusb" => :optional
  depends_on "qt5"

  def install
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
