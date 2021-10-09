class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm.git",
      tag:      "v0.11.0",
      revision: "82e4ffd9f4967d692e16377e8b68f8ec971984ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3eb4833efcae34ac92de8850d6f13b8770a4318a346566a3bb29c4bb45bb7282"
    sha256 cellar: :any_skip_relocation, big_sur:       "7c2c2b7280a1327a0c48229f2008b905cb6ffcb46f77246ffbf961d0d8d2859c"
    sha256 cellar: :any_skip_relocation, catalina:      "4dc71c67511cca66d0491362133aeb97ab4491e7482669ac175b6089d0821456"
    sha256 cellar: :any_skip_relocation, mojave:        "49ecd218120e585109d08e91522fd16fb34d86c071073325e2ac02f3e54bf5d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df1e58cae68dbdfe8ead4e49a19aeacd9d878954d0edba9f0ad74ad62a64ee2a"
  end

  depends_on "go" => :build
  depends_on "helm" => :build

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
