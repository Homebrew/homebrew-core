class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.38.8.tar.gz"
  sha256 "ed32ff9318ccded908823f84407ce7de745090e41109a4e5e69b331a32e79d74"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f1c8a4d956bd90b9edf252f92e07b84ae70af7c2d26a989566dd20a5f8b94d58"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fe7bbd2e337d7ac0bba857051708a3787fc2940c0bac5f5b88e86484b2094cf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "84274ba3063632ed093e7aef748ba7b176bcee870f99073d6c24540021db252b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "503e5a4dbd88103fa70c1336cc8e41287996a6bffb2833cdff23fae66e3042e7"
    sha256 cellar: :any,                 x86_64_linux:      "83c8ff7365690078fc23b56f30a7437087eec014cc8455f27afa7ef2a1ca7b3b"
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
