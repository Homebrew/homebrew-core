class Geoserver < Formula
  desc "Java server to share and edit geospatial data"
  homepage "https://geoserver.org/"
  url "https://downloads.sourceforge.net/project/geoserver/GeoServer/2.23.2/geoserver-2.23.2-bin.zip"
  sha256 "e333ad71459e6ffcee6c4637c0d09805e4ad45281ad9b9b506705afaa732782c"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef77db1edcb761685bcebe4e91c82eb5244bf78e1115a7c129529de2a78d25ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef77db1edcb761685bcebe4e91c82eb5244bf78e1115a7c129529de2a78d25ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef77db1edcb761685bcebe4e91c82eb5244bf78e1115a7c129529de2a78d25ea"
    sha256 cellar: :any_skip_relocation, ventura:        "ef77db1edcb761685bcebe4e91c82eb5244bf78e1115a7c129529de2a78d25ea"
    sha256 cellar: :any_skip_relocation, monterey:       "ef77db1edcb761685bcebe4e91c82eb5244bf78e1115a7c129529de2a78d25ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef77db1edcb761685bcebe4e91c82eb5244bf78e1115a7c129529de2a78d25ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0e2b2f455ce008eb494844c5b46e97d86906ef753ac3130bc83f69760404a7d"
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
