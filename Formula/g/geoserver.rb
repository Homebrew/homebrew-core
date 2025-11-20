class Geoserver < Formula
  desc "Java server to share and edit geospatial data"
  homepage "https://geoserver.org/"
  url "https://downloads.sourceforge.net/project/geoserver/GeoServer/2.28.0/geoserver-2.28.0-bin.zip"
  sha256 "4053c22b68dc0b7277d718e9bd6f3207932612678536eb241d9ff61a189ee22b"
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
    sha256 cellar: :any_skip_relocation, all: "64c3d9674ea5a3ffeacb782d3ec2e58af0857be89f4c514ef6868a51b1acd3ad"
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
