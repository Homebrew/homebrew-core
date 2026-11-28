class KubectlRadar < Formula
  desc "Missing open-source Kubernetes UI with a built-in MCP server for AI agents"
  homepage "https://radarhq.io"
  url "https://github.com/skyhook-io/radar/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "80789a71da8d02a2763857cf04e1b7ca757e195a4f5c604e3330dcf3a99dc650"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "4d56986b5168dd95a01b64c130fa5c547ca4ed31b4a6ca0fe923001dfdae2c3b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2ba994cd683af713ca7fd66cdc471c8b523b9847d1b642726499401dfd6bde5f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a6f5ef0f4273f15d2e5e80d6ac36bedf48027b09e7c8d4cd79a3db613bcfbb2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "72d84a647035216dd1eab264eafd4def5f0fe45a82052e42d9d5d93a7967ac2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0bb90339b38e3a79eb1434862f9c60e0587ca6c1153f688c5bededaa1871635b"
    sha256 cellar: :any,                 x86_64_linux:      "4454fd05cae0f33069db06a1ce43fa1119b7da3dfbcfbab95278e1b2fc332465"
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
