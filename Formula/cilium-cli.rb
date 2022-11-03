class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.12.6.tar.gz"
  sha256 "8938e52fc47d2e1b777046a6e878effdcaab5c62341b856ee767ebc25c4d9dcb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c02c8544265189f5b8bdf4b36da6b58c30caddb8bdc07d2ccd31648d1b007d24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9487ffcb15e22e2d18ce9202debcd590fbf447643fb6563395e3d42ccaacb4c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb84aa1aedd2d22b9fc40eabd1e5757e74b72e2fd881e8a98bb4e331ad72466d"
    sha256 cellar: :any_skip_relocation, monterey:       "a0108b21e863db9d9c1a8c47a0b5879c628e495fe439cc8302674eaf818db672"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccdce931d5d0825780cdf696230d3d206770966d68b1430b34331bd8465aec8d"
    sha256 cellar: :any_skip_relocation, catalina:       "7519aa19498ac90c2e27b54e65cb04bf4f7098baeac4250336a22afff2c657b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18e9c0ab7acb006c845dbd1bcaff878f38f5488d9a92b49fc466e338dcc506c1"
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
