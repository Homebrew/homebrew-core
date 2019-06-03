class Gpsbabel < Formula
  desc "Converts/uploads GPS waypoints, tracks, and routes"
  homepage "https://www.gpsbabel.org/"
  url "https://github.com/gpsbabel/gpsbabel/archive/gpsbabel_1_6_0.tar.gz"
  sha256 "ad56796f725dcdb7f52d9a9509d4922f11198c382fe10fc2d6c9efa8159f2090"

  bottle do
    sha256 "afa69a0f0729d4ba82d1f36edee585ed6dc88be4d36d4bd93d0c8512ee13ff11" => :mojave
    sha256 "4c3f17308d3d81e9a3ca96fd278e30a0cf927642a82cdb76a46ca649a6d9bb6f" => :high_sierra
    sha256 "be91d28547a74b5a5e5564ee9b6bc5fe2c54dc2a62afd992ca00a4e0836e5dfb" => :sierra
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
