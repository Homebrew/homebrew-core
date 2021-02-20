class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm.git",
      tag:      "v0.7.0",
      revision: "75423a0b4a3d5e9114fd93a133d2485171243c4b"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0a0ec8143cf42a76cad79c8a90ba42f1ee940ed2617f2a68fd66cb6143191d6e"
    sha256 cellar: :any_skip_relocation, big_sur:       "3573b793dceb91ba10cc42a70da33c3fe859baa7264e2cbb6149717c13427ae9"
    sha256 cellar: :any_skip_relocation, catalina:      "ee3e3de0a60d14d84038db764b49a7c2078c9c8a582afe92e79de099fe208f85"
    sha256 cellar: :any_skip_relocation, mojave:        "74c6970fdfbd37faf0dd650aea5aae3c875236a38103f7c3809945015b2e5d77"
  end

  depends_on "go" => :build

  def install
    ENV["VERSION"] = "v"+version
    system "make", "build-osm"
    bin.install "bin/osm"
  end

  test do
    assert_match "Error: Could not list namespaces related to osm", shell_output("#{bin}/osm namespace list 2>&1", 1)
    assert_match "Version: v#{version};", shell_output("#{bin}/osm version 2>&1")
  end
end
