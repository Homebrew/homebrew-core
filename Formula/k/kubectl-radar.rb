class KubectlRadar < Formula
  desc "Missing open-source Kubernetes UI with a built-in MCP server for AI agents"
  homepage "https://radarhq.io"
  url "https://github.com/skyhook-io/radar/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "7f103ed8d53b19ae8f1107cfcf6d19b9c1cc928a2fb1b8bad307278e1798a327"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "47e04ddd7d1b656f9f8ba6ab9b36ba6bc27d7045f1e93505783b236b09b1c2bc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2208422f95b50bf4f1e0912a7922ed2cc9759c5cf491ab800bdf12b53575779e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f51d9b97d75721877471ecd32289055f8c7fd3a59247f450830099c46df09b25"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bfa0a647b4194e1cfff3c1daa72bf5d464143cfcc39bcf27b93c0fe6a64c5aae"
    sha256 cellar: :any,                 x86_64_linux:      "e7080b1e1a6b170acea0c978ba30b998a32d21f11ea44e33310f06d30b7c1ad9"
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
