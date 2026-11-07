class KubectlRadar < Formula
  desc "Missing open-source Kubernetes UI with a built-in MCP server for AI agents"
  homepage "https://radarhq.io"
  url "https://github.com/skyhook-io/radar/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "dbd0ef17b1a0d0d329c34887e6926842f6c61406d1355e3ba3aadea85f1dc65f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5f4e69141990316b8d0e9977b63425fa07b2ec852b45bdc148234e2c1c6080a5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "faf20d0b503e29fa94a464218f22cc6a16af9a6ebe32522a4a0e4b2a6d9e0440"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a7320bcdb96ba9477fc49db357c2d97048b7955fb2bc95de492b519ace5c49a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "62221c7b0670710e6b6e9009452f9e3bb2cb264859f377b8c0e26d5b661f17d6"
    sha256 cellar: :any,                 x86_64_linux:      "f2dc93590a4036eac04c4c5f74e6494934ba148ab7c1a38d2ab294fd63b49978"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  deny_network_access!

  def fetch
    system "npm", "ci", *std_npm_args(prefix: false)
    system "go", "mod", "download"
  end

  def install
    system "make", "build", "-j1", "VERSION=#{version}"
    bin.install "radar" => "kubectl-radar"
    bin.install_symlink "kubectl-radar" => "radar"
  end

  test do
    assert_equal "radar #{version}", shell_output("#{bin}/kubectl-radar -version").chomp
    assert_match "failed to initialize K8s client",
      shell_output("#{bin}/kubectl-radar 2>&1", 1)
  end
end
