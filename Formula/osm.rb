class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm.git",
      tag:      "v0.9.0",
      revision: "96498ba51205a08530b17b17d5ee0d53b005f874"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4eb537bd502ed21ebec9c130a278ed222c1c2c5b7fccb75eca277cc561cba6ea"
    sha256 cellar: :any_skip_relocation, big_sur:       "d4bd3b334c8d769abb682cf7c39886a1f6788a7a3dcc4720887a78022eb8e9a5"
    sha256 cellar: :any_skip_relocation, catalina:      "878289088fb76f829d453916f4a23057dd3e145de96621bd897c889695c9c4ed"
    sha256 cellar: :any_skip_relocation, mojave:        "5481457927e9d6fca659375c45995d2972e066ba9572dcd04901ffaadd91517a"
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
