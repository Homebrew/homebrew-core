class Osmosis < Formula
  desc "Command-line OpenStreetMap data processor"
  homepage "https://wiki.openstreetmap.org/wiki/Osmosis"
  url "https://bretth.dev.openstreetmap.org/osmosis-build/osmosis-0.45.zip"
  sha256 "d801f1a8806359efe95d604bb8a770294bca6fcaf32b50672d2891487b97c6d1"

  bottle :unneeded

  # need to adjust home dir for a clean install
  patch :DATA

  def install
    bin.install "bin/osmosis"
    libexec.install %w[lib config script]
  end

  test do
    path = testpath/"test.osm"
    path.write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <osm version="0.6" generator="CGImap 0.5.8 (30532 thorn-05.openstreetmap.org)" copyright="OpenStreetMap and contributors" attribution="https://www.openstreetmap.org/copyright" license="https://opendatacommons.org/licenses/odbl/1-0/">
      <bounds minlat="49.9363700" minlon="8.9159400" maxlat="49.9371300" maxlon="8.9173800"/>
      <node id="4140986569" visible="true" version="1" changeset="38789367" timestamp="2016-04-22T15:17:02Z" user="KartoGrapHiti" uid="57645" lat="49.9369693" lon="8.9163279">
        <tag k="bench" v="yes"/>
        <tag k="bin" v="yes"/>
        <tag k="bus" v="yes"/>
        <tag k="highway" v="bus_stop"/>
        <tag k="name" v="Bahnhof"/>
        <tag k="network" v="RMV"/>
        <tag k="public_transport" v="platform"/>
        <tag k="shelter" v="yes"/>
        <tag k="tactile_paving" v="no"/>
        <tag k="wheelchair" v="no"/>
        <tag k="wheelchair:description" v="Kein Kasseler Bord"/>
      </node>
      </osm>
    EOS

    system("#{bin}/osmosis", "--read-xml", "file=#{path}", "--write-null")
  end
end

__END__
--- a/bin/osmosis 2010-11-16 06:58:44.000000000 +0100
+++ b/bin/osmosis  2010-11-23 12:13:01.000000000 +0100
@@ -83,6 +83,7 @@
 saveddir=`pwd`
 MYAPP_HOME=`dirname "$PRG"`/..
 MYAPP_HOME=`cd "$MYAPP_HOME" && pwd`
+MYAPP_HOME="$MYAPP_HOME/libexec"
 cd "$saveddir"
 
 # Build up the classpath of required jar files via classworlds launcher.
