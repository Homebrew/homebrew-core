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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "032741f4b0f70ba8fe13cb3f094c283b4faf2b888e5218deaeaaa7ccad1dfad5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "53bd42e49cfd6b696529a7eb7a9be9bb04f6d24f0ba3df55907db24fb6d4be6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ba6c19cf5ca0c61882850d71cfd0b41c4421c26e78a38ed0c53d3f958b507efb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ac9dd6cbd76c1c856e7ead3d0b4ae7ad73c8db432a723eefb179ad07f90f63c5"
    sha256 cellar: :any,                 x86_64_linux:      "50c477d91c8224925ec067634eac7cdc19340d1604cbb84cf3f14fa44b9dadd9"
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
