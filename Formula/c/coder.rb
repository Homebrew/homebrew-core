class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.38.6.tar.gz"
  sha256 "e47ede19f29183c214509494d9ab7c5ccf8a228caca3d7f886bca095763ebd7f"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7eba07ace829ad4884bd5bce1663c1e9ef0d86deaab2e3be523ae70a0aba5eb9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bf24d1bfa592cbfa620541631f6afdf5f244401a75de33f3f4267139e6434e57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d1fcdd9bb844175448392ffd0579d6d7057e6f0cc3e5247e6719b53b6f78b79f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "33a8f2c3e79358db701c6ac9982c5d47e23852185c98fba8a19b9c5d88e3ae1f"
    sha256 cellar: :any,                 x86_64_linux:      "819f11fc9274c5403c6a6b5214169ec288b507715f7ca5be39b9e2e995050e85"
  end

  # TODO: unpin go@1.26 when coder supports go 1.27
  depends_on "go@1.26" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
