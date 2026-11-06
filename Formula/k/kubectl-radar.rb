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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "49da3717e258f03b96bd945734fdc7e5cf7fbab1c30f980decf2427897ba1157"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "19e66f90acf702679a2ebfca992184bc0a04e354aa83cf240dd29c3ba3e566b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7a2e34c855217b55b34ecd5cbb8786b87bafbcaac725d6c7bab27601adf62a73"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "80103afded2cf93616abf2f355905fb8be02b1682608642c3be1e903a2bcc2af"
    sha256 cellar: :any,                 x86_64_linux:      "4df736ff573a703b011bda60e07cc4cbfffda7fc6496ddea4c45241f47ddc61a"
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
