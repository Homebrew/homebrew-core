class KubectlRadar < Formula
  desc "Missing open-source Kubernetes UI with a built-in MCP server for AI agents"
  homepage "https://radarhq.io"
  url "https://github.com/skyhook-io/radar/archive/refs/tags/v1.20.3.tar.gz"
  sha256 "aaf0710f261f6114431b9c8fd2d0ab08a1f50e5714d9cdfe0741e36e9bf1931d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b913d485098c17319f546366b53fa52404df1b88b46fc40361d0196a782eebb4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "954f3beef0a32ae873aa935064a04b3a9d2d136641da24eda5da059b38d00ba9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9a6541187ead1f756fbb04ae61624b25896f1acb9d54f41c72d386e682548cab"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "11c59869882008973b93418066d2537557f980a570124f933f35dfa0477846a6"
    sha256 cellar: :any,                 x86_64_linux:      "2f8a317bdd423236d12dfdb14cec1b1d932ad1350f40ab100b9c9acaac98cd4b"
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
