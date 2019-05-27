class Geoserver < Formula
  desc "Java server to share and edit geospatial data"
  homepage "http://geoserver.org/"
  url "https://downloads.sourceforge.net/project/geoserver/GeoServer/2.15.1/geoserver-2.15.1-bin.zip"
  sha256 "eff6602bee2881d88181f9cabafc4f08558ca6dad3bbfe4cb53cd58cf38af22c"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    (bin/"geoserver").write <<~EOS
      #!/bin/sh
      if [ -z "$1" ]; then
        echo "Usage: $ geoserver -start | -stop | path/to/data/dir"
      elif [ $1 == "-start" ]; then
        cd "#{libexec}/bin" && sudo ./startup.sh
      elif [ $1 == "-stop" ]; then
        cd "#{libexec}/bin" && sudo ./shutdown.sh
      else
        cd "#{libexec}" && java -DGEOSERVER_DATA_DIR=$1 -jar start.jar
      fi
    EOS
  end

  def caveats; <<~EOS
    To start geoserver:
      geoserver path/to/data/dir
  EOS
  end

  test do
    assert_match "Usage: $ geoserver -start | -stop | path/to/data/dir", shell_output("#{bin}/geoserver")
  end
end
