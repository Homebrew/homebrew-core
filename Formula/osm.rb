class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm/archive/v0.6.0.tar.gz"
  sha256 "303471eb096ffcedfb433d8531ab685aacd587f43a86021561d38d2a42fa523d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8dc670b18fdb0036d0ce3377ed32ca503ce2e13bbb16f3e72fc07f48253f6225" => :big_sur
    sha256 "1f3d995041e60a501c6083564975b18bc9e8a02501690e38a90d2b47f01248c5" => :catalina
    sha256 "4723cf4c0ce37c95b6bce93a40888b08b3bb0c18a43fb8e30c6f257da5a58d1f" => :mojave
    sha256 "227c487c1e3a24d0ddd4449a357258a8e095d03aee5ebd497eb352274ddd3b20" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build-osm"
    bin.install "bin/osm"
  end

  test do
    assert_match "Error: Could not list namespaces related to osm", shell_output("#{bin}/osm namespace list 2>&1", 1)
  end
end
