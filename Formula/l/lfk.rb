class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.15.tar.gz"
  sha256 "3172412630e1d25ce0433bfcf9dbc9c434875722354d0a18bd903f96b4e59003"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aad4fb8783cc8399b8f6a9677d05f12c053cff94bb8b65be8e326cfdc0f167d5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0292cb40e3bebd9abf30ee8b7b12be90345ce803506c19c62d1cff708b81c6ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "66f7c458038f3c5040793d664f5b52063a3d68478b077d5a83c2672ef08f8590"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f0ed78995b653f67566e28b4cdca15b92cad5c9347783b5ceeacb30420b28fbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2b31642d604f74394833dac2e3442885f4594176ae76225646c69d8e03f34e11"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/janosmiko/lfk/internal/version.Version=#{version}
      -X github.com/janosmiko/lfk/internal/version.BuildDate=#{Time.now.utc.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # This program is TUI-only
    assert_match version.to_s, shell_output("#{bin}/lfk version")
  end
end
