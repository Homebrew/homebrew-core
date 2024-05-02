class Geoserver < Formula
  desc "Java server to share and edit geospatial data"
  homepage "https://geoserver.org/"
  url "https://downloads.sourceforge.net/project/geoserver/GeoServer/2.25.0/geoserver-2.25.0-bin.zip"
  sha256 "99a583451228e4caa36fa2b5356169966430bc9f5f2d71a77a565cb25c29e0ea"
  license "GPL-2.0-or-later"

  # GeoServer releases contain a large number of files for each version, so the
  # SourceForge RSS feed may only contain the most recent version (which may
  # have a different major/minor version than the latest stable). We check the
  # first-party download page for stable versions, since this is reliable.
  livecheck do
    url "https://geoserver.org/release/stable/"
    regex(%r{/GeoServer/v?(\d+(?:\.\d+)+)/?}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b99606ee73bb6cf2768fbaaa9c459f1e3f99919ea7a24b1e47fe77dc85e7868f"
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
