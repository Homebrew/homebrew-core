class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.38.11.tar.gz"
  sha256 "3958025e1bfb4005790f9c058c99fbf25c5f027c1fe8f7e83fa4e96cfe315578"
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
    manifest_sha256 "776e6c5cbde472cae4f38676ee32f34898e2f731e0708a01a1d7317f090b05da"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a99a3c3445af5ea4abf2ea776bae90decc175077acd707d2d5bd9177590a01da"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "112443adc9075c69a9be1b7eae5ee1b74b8b71d2e0915950a76fb5b2c97ce77a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ee86b90e1c77d765467f076de89630a55012fae6c05fca18671144a3c4d6d854"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d114034d7b7395c086bd5da3fb6fb648a381d90f42a2cd741e198f17af4a9b45"
    sha256 cellar: :any,                 x86_64_linux:      "414e96681b4e778fafd6830e7999886afaefb77da1ec7a8d989920cea324590e"
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
