class KubectlRadar < Formula
  desc "Missing open-source Kubernetes UI with a built-in MCP server for AI agents"
  homepage "https://radarhq.io"
  url "https://github.com/skyhook-io/radar/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "c5a8a55da42db158ffdb3a6615704ed7267e01b0ababe25a988f3dc11fbb42e2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "32381ff28f1a84891cfb1ca29fd0b531da3b107b566d32b601d2b4d760750ab5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c19a445d024e028ccf13f6206956780c7dba2ef2d9fb16748c4d2611cff09560"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4e44b099ba9c16e9fe5d30dc2fddd294f8effce663af9286ad41c3d03dfde480"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8e908befbefdd2fd4a8ed8cac2b93e8a2962478f8a2d6471e48615cfcbe92772"
    sha256 cellar: :any,                 x86_64_linux:      "d6cb582712345c492618ae5d3c98a80da565568c7b334de5b7e4a9f54abb20ac"
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
