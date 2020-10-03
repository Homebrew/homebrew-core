class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm/archive/v0.4.0.tar.gz"
  sha256 "72586aa8a07bcc3163d921c5b2afa0adec8688058f62801f1377a61a91573328"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d919080c06f48497aa61afa3218a14e16deb130de69237b55e9d55c18bd9cd5" => :catalina
    sha256 "6d61028e903da81e664ee9994c3948353303d52212f1c1e894af0baa15b259ca" => :mojave
    sha256 "08c329ad3fa81cd0da5e94015d462c35cb7764f7a1e490bdac51e8d3021ebbb3" => :high_sierra
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
