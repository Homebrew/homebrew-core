class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm/archive/v0.7.0.tar.gz"
  sha256 "ab396a2f156e92fb2215905562f062ee92f96abd8a4d979cfb8c63940c8d5f26"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "85fc54f1acd5b1a2bcf7344f176c5741485893d29073588986c3125f9ed64a7d"
    sha256 cellar: :any_skip_relocation, big_sur:       "a38e413d78883cd135b3d71d18570ed3b10fcc1f0b38b291b0c294bbcd416553"
    sha256 cellar: :any_skip_relocation, catalina:      "0a207395ca9107cc1ccc2e43e2b8b3306ee224add2b42ab597bb542a00ac8bb4"
    sha256 cellar: :any_skip_relocation, mojave:        "f058402b5fa2a66548b7694ce4887160cd25b27f137bb6ce5ffb864c8b113f0f"
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
