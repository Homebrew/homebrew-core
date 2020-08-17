class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm/archive/v0.3.0.tar.gz"
  sha256 "d4b9fa2789fd8dfadae9df5a8a80d3e6db24cca7629a52b0d61608761ae70d73"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c33f82bb8363354a301b64ffa8508e127ca793940576c7eb45b88bf7169cf13f" => :catalina
    sha256 "8597c2048dffd49f295c3166cbb5340175ba14abc2cca66e507b600acfb75d57" => :mojave
    sha256 "0c3fbe6574723c2281a794671468eab84fa6b33ec21a1a27bda1d23ae9375335" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build-osm"
    bin.install "bin/osm"
  end

  test do
    assert_match "Error: Error fetching kubeconfig", shell_output("#{bin}/osm namespace list 2>&1", 1)
  end
end
