class KubectlRadar < Formula
  desc "Missing open-source Kubernetes UI with a built-in MCP server for AI agents"
  homepage "https://radarhq.io"
  url "https://github.com/skyhook-io/radar/archive/refs/tags/v1.21.4.tar.gz"
  sha256 "085f9b26db451d5ae5f6430df61d65015b0284e12abfca1716185736a700536e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "666fe3f25408e72d86819cc317add0df630ac20604a8efd735c59e06e2876177"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "37ec0d1a053d0b873b627ba57a5c2cf06ea62f002c2ebce22b6f6fa219ecfae4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d707065a256743fb9548703e65596fd4dc5fece891418cd9b6fb22127c333cdb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "12c3d88482b0971a65988751efa85213e5ffc54a25ffe5ae1a959ccfddc3e64f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "05180a3a22b2365b0033181ca04716a26667d0e19ee17b8cd2e9144210f5ebb1"
    sha256 cellar: :any,                 x86_64_linux:      "af21664acee9f823a7bdb23e14f7041574c111cdaa2f2f112d59059557b3594a"
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
