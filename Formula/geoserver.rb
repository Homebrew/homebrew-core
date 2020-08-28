class Geoserver < Formula
  desc "Java server to share and edit geospatial data"
  homepage "http://geoserver.org/"
  url "https://downloads.sourceforge.net/project/geoserver/GeoServer/2.17.2/geoserver-2.17.2-bin.zip"
  sha256 "2469c4f8735dea0604dabe975c37663bbaf9adc569cc888ce24b9e987dc06400"

  # GeoServer releases contain a large number of files for each version, so the
  # SourceForge RSS feed may only contain the most recent version (which may
  # have a different major/minor version than the latest stable). We check the
  # "GeoServer" directory page instead, since this is reliable.
  livecheck do
    url "https://sourceforge.net/projects/geoserver/files/GeoServer/"
    strategy :page_match
    regex(%r{href=(?:["']|.*?GeoServer/)?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    (bin/"geoserver").write <<~EOS
      #!/bin/sh
      if [ -z "$1" ]; then
        echo "Usage: $ geoserver path/to/data/dir"
      else
        cd "#{libexec}" && java -DGEOSERVER_DATA_DIR=$1 -jar start.jar
      fi
    EOS
  end

  def caveats
    <<~EOS
      To start geoserver:
        geoserver path/to/data/dir
    EOS
  end

  test do
    assert_match "geoserver path", shell_output("#{bin}/geoserver")
  end
end
