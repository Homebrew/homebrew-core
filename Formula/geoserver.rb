class Geoserver < Formula
  desc "Java server to share and edit geospatial data"
  homepage "https://geoserver.org/"
  url "https://downloads.sourceforge.net/project/geoserver/GeoServer/2.22.1/geoserver-2.22.1-bin.zip"
  sha256 "7e6ae55c15bbd88e541b9a1a88d026d912cf4552e01fe0b5101b4c81d8c21cf6"

  # GeoServer releases contain a large number of files for each version, so the
  # SourceForge RSS feed may only contain the most recent version (which may
  # have a different major/minor version than the latest stable). We check the
  # "GeoServer" directory page instead, since this is reliable.
  livecheck do
    url "https://sourceforge.net/projects/geoserver/files/GeoServer/"
    strategy :page_match
    regex(%r{href=(?:["']|.*?GeoServer/)?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a14f6ed90e294dc7e8ee4679e1f067dca6770ed74c71522ec1c39a83acc3fcc9"
  end

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
