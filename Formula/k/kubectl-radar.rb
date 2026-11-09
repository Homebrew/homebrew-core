class KubectlRadar < Formula
  desc "Missing open-source Kubernetes UI with a built-in MCP server for AI agents"
  homepage "https://radarhq.io"
  url "https://github.com/skyhook-io/radar/archive/refs/tags/v1.20.2.tar.gz"
  sha256 "23f4c3faca02fa7ac179766f7155118dc698b7770d9746ba34c1859a8d77acbc"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2710b8a11b636f7a49c3cc8a8fa1e3e6c8189c5a5c16b7756455f414f013875e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed2b4c2ee7a7c7e42614695d545bf7c70a35978744b49693625ead3942d7b19d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "29fc4643d2bb5cb50072eca042e7d003b9691d30cc86fda12094f056b0e06e42"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b3a355f12e59911f0628d5dcbedf8a1941b5aa23d255bac4c193429e5a3163bb"
    sha256 cellar: :any,                 x86_64_linux:      "eee58160afe2d6d735aec0efc5031bfef8af1b0a516072fa8b4d0de55df1e7a4"
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
