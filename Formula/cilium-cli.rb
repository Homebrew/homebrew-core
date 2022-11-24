class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.12.9.tar.gz"
  sha256 "530f547a75377bc52fde8e3e20aa293ed5374264c6a66dd214d67c0afb7d4737"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfc0a4f5cfcd8c2344ec1886c8f9d2e890519b9da5eae63c9fd60fd4547c6f2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ece4d0831ced56beb6de325eae4e65522ce3aa99856407810cb7f2a2c0ee1a41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d88f39db63b64e123dc86d09015419395675353c5401ff6250a513b25da139b"
    sha256 cellar: :any_skip_relocation, monterey:       "4a904f662dc36eb174d874e2eff5f54fc46689431e6aef671f50674ce256d378"
    sha256 cellar: :any_skip_relocation, big_sur:        "c10645dd240786915bd191bacb3eb6336eb6e2934b61bc0cbc7d4cd21ca62b9d"
    sha256 cellar: :any_skip_relocation, catalina:       "db9c3266f3dd2636530c4ed842c87420c02be9cf4406e816acbecd59dc7e9b62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "619ff5996214d4ae44f85ba5b9233c4db24e21b1f7053fb05075bec1c80f5379"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/internal/cli/cmd.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match('Cluster name "" is not valid', shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
