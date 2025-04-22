class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.20.2.tar.gz"
  sha256 "70d38e72778c2d5fc9dc3f02dbd7b61b2548ccaaf8cf666165bb24546aae7479"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c867a3d71c8af7972efc6ffb53cbe0eced87970e677abd57ddcca4ec2a0c98f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3456e8e1fa9c6bbf1760f733c2e841c8940bcaca394490c7eec053320f8d62de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6cc404c4b634385b92f4cd0cbeccbb3db64d9c1a10e26aa5d89612dbdd0f9388"
    sha256 cellar: :any_skip_relocation, sonoma:        "3814946122306f1a92031c77673c93a7852dedd78e4e95ab384b211841b15e7c"
    sha256 cellar: :any_skip_relocation, ventura:       "399e958e3de77d27755cdccc2c63220c75515c05a4f31c25454369a087c5671b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c05ae85ccab4d1b8fdced333f386637e06e645c8560cf74280ab5c6d5db52ad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1918bf09970a545d2dce16646332c2ea639ca7b80fbd8423308065f5ae50a70d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
