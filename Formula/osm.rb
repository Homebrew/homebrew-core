class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm.git",
      tag:      "v1.2.1",
      revision: "0b6a18f080d3e29922332464ffa81a8457f847e1"
  license "Apache-2.0"
  head "https://github.com/openservicemesh/osm.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4faf805c4c67dd4f32a568903fe3c5f13c617e066d8b2e54da38d64f90d72021"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7a9bd8e723337350814d60152b8eb3452e1a5fa74d705ea11588f825285ac4f"
    sha256 cellar: :any_skip_relocation, monterey:       "3e5f480b48f4558c71e4d92a0905bc8a0c0d2c6e8cbdf866b6f7cd35c71302fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "48325be15038b809bcbf508f752555b5737ca158941af2ea61c125ad4842c282"
    sha256 cellar: :any_skip_relocation, catalina:       "612fa0aee77eee6b2db2b4085d2519d22fc53815bfac3d25ae45aa50d56811e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bbe8d33a1e61d83f6b1fa4b3c0f28b78bc9f75f1786bfd0f29b526bedcc6a67"
  end

  depends_on "go" => :build
  depends_on "helm" => :build

  def install
    ENV["VERSION"] = "v"+version unless build.head?
    ENV["BUILD_DATE"] = time.strftime("%Y-%m-%d-%H:%M")
    system "make", "build-osm"
    bin.install "bin/osm"
  end

  test do
    assert_match "Error: Could not list namespaces related to osm", shell_output("#{bin}/osm namespace list 2>&1", 1)
    assert_match "Version:\"v#{version}\"", shell_output("#{bin}/osm version 2>&1", 1)
  end
end
