class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm/archive/v0.1.0.tar.gz"
  sha256 "2074040e13b78022b5cf041c7c0102eb19c16c5924273c46ac376561e2ac0c65"
  license "MIT"

  depends_on "go" => :build

  def install
    system "make", "build-osm"
    bin.install "bin/osm"
  end

  test do
    assert_match "No checks run", shell_output("#{bin}/osm check 2>&1")
    assert_match "Error: Error fetching kubeconfig", shell_output("#{bin}/osm namespace list 2>&1", 1)
  end
end
