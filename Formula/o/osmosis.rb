class Osmosis < Formula
  desc "Command-line OpenStreetMap data processor"
  homepage "https://wiki.openstreetmap.org/wiki/Osmosis"
  url "https://github.com/openstreetmap/osmosis/releases/download/0.49.2/osmosis-0.49.2.tar"
  sha256 "2a23a7bf7499a0727ae6987cf66fcafc03b37379dc02177c730f352bd67a0b97"
  license :public_domain

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "bbf0840fce8067bb973ff59a7e9d9774178ae11b9af976aa0842e80b90264b00"
  end

  depends_on "openjdk"

  # need to adjust home dir for a clean install
  patch :DATA

  def install
    libexec.install %w[bin/osmosis lib script]
    (bin/"osmosis").write_env_script libexec/"osmosis", Language::Java.overridable_java_home_env
  end

  test do
    path = testpath/"test.osm"
    path.write <<~XML
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
    XML

    system(bin/"osmosis", "--read-xml", "file=#{path}", "--write-null")
  end
end

__END__
diff --git a/bin/osmosis b/bin/osmosis
index 04b040a..648824e 100755
--- a/bin/osmosis
+++ b/bin/osmosis
@@ -84,6 +84,7 @@ done
 # shellcheck disable=SC2034
 APP_BASE_NAME=${0##*/}
 APP_HOME=$( cd "${APP_HOME:-./}.." && pwd -P ) || exit
+APP_HOME="$APP_HOME/libexec"

 # Use the maximum available, or set MAX_FD != -1 to use that value.
 MAX_FD=maximum
