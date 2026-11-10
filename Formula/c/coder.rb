class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.38.7.tar.gz"
  sha256 "ec4a4577deb44cc42a7bed9c1c16c5658602dafaa16d5c487e2ebc3bbbdfee3a"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c8de65a0578671026f9b5abdec70c378bf8b0e6397bb07374579b9a6b38130f7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "688a30b8c10c509f7e6c02ca9e124b74c0e405e9035de2aaa7ac0863edf5687b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f08c08b4977add0ceb010f88ebcfcfb62ddc5a89ae59696b8b9228b2f7ce72d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d1301f5a154f7ef07f70ba41fa9b09e116d9880310b1917ff35a22056e1cbff6"
    sha256 cellar: :any,                 x86_64_linux:      "0dd3f65a1d888878e000c843fe3c19a01e7b0143f72e529658b79b3ce8078c5e"
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
