class Geoserver < Formula
  desc "Java server to share and edit geospatial data"
  homepage "http://geoserver.org/"
  url "https://downloads.sourceforge.net/project/geoserver/GeoServer/2.14.3/geoserver-2.14.3-bin.zip"
  sha256 "07056c692efc5a49726dca3e952767ebcaadfae50cd450e201c02df5426f5ca0"

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

  def caveats; <<~EOS
    To start geoserver:
      geoserver path/to/data/dir
  EOS
  end

  test do
    assert_match "geoserver path", shell_output("#{bin}/geoserver")
  end
end
