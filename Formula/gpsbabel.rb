class Gpsbabel < Formula
  desc "Converts/uploads GPS waypoints, tracks, and routes"
  homepage "https://www.gpsbabel.org/"
  url "https://github.com/gpsbabel/gpsbabel/archive/gpsbabel_1_6_0.tar.gz"
  sha256 "ad56796f725dcdb7f52d9a9509d4922f11198c382fe10fc2d6c9efa8159f2090"

  bottle do
    sha256 "685947e84880f27a16a442c10456990f9ede1efa8adf723fa217ba7ac5123ff7" => :catalina
    sha256 "0d5fa17f760e4ff0ebf88bf4b461c1fba6498278edd57ab77caee7576f5c4609" => :mojave
    sha256 "e147b5217a57fdf32a8073f53718e6423f227e967f9d495cb3a0bc38b5e2ad3a" => :high_sierra
    sha256 "e982a298816049c9094762699799f238cfc8d7804cf5d72f6816ebd0e8aa414e" => :sierra
  end

  depends_on "libusb"
  depends_on "qt"

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
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
