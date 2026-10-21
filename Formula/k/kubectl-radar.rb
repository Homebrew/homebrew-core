class KubectlRadar < Formula
  desc "Missing open-source Kubernetes UI with a built-in MCP server for AI agents"
  homepage "https://radarhq.io"
  url "https://github.com/skyhook-io/radar/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "f520c414baf092cabe6ce63569d87652c1710f47d85c17c497280884bb708afd"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e43f5162e534368dad738627cd6daca05ea2e1b571027c4ab1664374e4f089fa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "44c80c2af880f910f107a0404a834de520d988c1ae0d51d18baea363f89322b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a4276f6159625cc4209c3494af117d23a1a75a9b62e66357d2b5832065a4c11f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cb634cf27274b382fd789fa7e0cb786d040188255bf1a54bb1af338f1c87ad5f"
    sha256 cellar: :any,                 x86_64_linux:      "c367fd7e4921389a59e95080299d5cc1a6769426428ba8e7e28d40ab3d49a45e"
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
