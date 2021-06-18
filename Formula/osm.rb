class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm.git",
      tag:      "v0.9.0",
      revision: "96498ba51205a08530b17b17d5ee0d53b005f874"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3d8709f004c5ded4a784e692afb3deafc5076139466d7189a091e417b129682b"
    sha256 cellar: :any_skip_relocation, big_sur:       "685f0f46db9f85a1eb9cc7e99ccab7ada8f782fa4aa3a619e30648f8cf5a47df"
    sha256 cellar: :any_skip_relocation, catalina:      "87de89b61c2a6247f28d6cfd5beda800acdc3af32c3588a41a83792e1db9e9f9"
    sha256 cellar: :any_skip_relocation, mojave:        "e92984154e7dbe938136b359814127453430c32aeaee9a0fd1fe6f0269c28dbb"
  end

  depends_on "go" => :build

  def install
    ENV["VERSION"] = "v"+version
    ENV["BUILD_DATE"] = Time.now.utc.strftime("%Y-%m-%d-%H:%M")
    system "make", "build-osm"
    bin.install "bin/osm"
  end

  test do
    assert_match "Error: Could not list namespaces related to osm", shell_output("#{bin}/osm namespace list 2>&1", 1)
    assert_match "Version: v#{version};", shell_output("#{bin}/osm version 2>&1")
  end
end
