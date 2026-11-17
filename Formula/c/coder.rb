class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.38.10.tar.gz"
  sha256 "0f5d4a367d7f6410b392430fb631ffb54157e6e30c06394147f7f619451185df"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0822196817ddbde8082aa06d0a44c799ed9bd9a454bbcf420560ae11c1fff753"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a3d4e0ca52033809ed9a4619461277a20200e562645ec43d48a7bf4b71d6fbc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a3049235a61d747ccd76fec7003011927d14e44956d205cda82c16f2b9d837e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "040c75eb4da80ff91279cc637cc53fc7d5f9dc4f79e4125ea4d998cddfbd2434"
    sha256 cellar: :any,                 x86_64_linux:      "8d9d15f58622be838becb7423fbfa3b2d44c876454dc66718d6c0e7a3c2fdfc1"
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
