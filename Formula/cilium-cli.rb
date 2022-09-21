class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.12.4.tar.gz"
  sha256 "271dd1285b19b7e8d6e2eecae0059b7a22fe87c2a8000c599997397d2494d0d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d56ee17bb64125cdc0b21576bdec3c78bc56430bf865e459f47c0f0a086ba6e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4090bdf29715d8414c7a26654302f095b22c81827d18eab2c9e81643dece1eb8"
    sha256 cellar: :any_skip_relocation, monterey:       "6b97794f0db710d193a7adec386297a9b884d70be21e61441fea9b96def9c09c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0185a941d5ac51e96d55e0e64153cba47ffd20ef1ef16694d08dc87673f7c5c"
    sha256 cellar: :any_skip_relocation, catalina:       "be41977f31e1dbb4f35ca740c64c1534ad7ce233714805782a008bbe00661257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47d1791ce90fd04c3ac4d1ad111d816e83e0d4b2730c10a75e387704fee78a27"
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
