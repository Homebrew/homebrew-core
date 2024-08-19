class Geoserver < Formula
  desc "Java server to share and edit geospatial data"
  homepage "https://geoserver.org/"
  url "https://downloads.sourceforge.net/project/geoserver/GeoServer/2.25.3/geoserver-2.25.3-bin.zip"
  sha256 "1265b78b4aa2ecfe3c01fb42cfbb6a2365adbddcb7729c91e7bface36758c2df"
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
    sha256 cellar: :any_skip_relocation, all: "9fc2d2bf95167a3362011d2f155366c55738457bd1118810e4710d8a5a44c969"
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
    assert_match "geoserver path", shell_output(bin/"geoserver")
  end
end
