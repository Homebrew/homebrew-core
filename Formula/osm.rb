class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm.git",
      tag:      "v0.9.1",
      revision: "7b40684d291691dac7374c70ae647889e6494b48"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2e0bf195cffe693a6e8d1fb3479e1eddab63bf9a7c8c1e81c678ceb3262e249e"
    sha256 cellar: :any_skip_relocation, big_sur:       "f897f3a48d6e621244a14cc0a5eb080630ddf1f941b8b15398dcae3ca3e341d2"
    sha256 cellar: :any_skip_relocation, catalina:      "6041b995055d68a76521ac973b87682e94967d1ccc8ac9464ff4d47cea3c788f"
    sha256 cellar: :any_skip_relocation, mojave:        "897ae43e01ca8934363482d67f6f0221a95d764b2f56bae4464f48c2b5f01c0d"
  end

  depends_on "go" => :build

  def install
    ENV["VERSION"] = "v"+version
    ENV["BUILD_DATE"] = time.strftime("%Y-%m-%d-%H:%M")
    system "make", "build-osm"
    bin.install "bin/osm"
  end

  test do
    assert_match "Error: Could not list namespaces related to osm", shell_output("#{bin}/osm namespace list 2>&1", 1)
    assert_match "Version: v#{version};", shell_output("#{bin}/osm version 2>&1")
  end
end
