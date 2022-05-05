class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "f1becdf87c0f1cfedcf206297f9f2371d31bc467b6c3f6d35af074c73f5d30ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e3fa6bb68acba294a8c8ee7516137a42eaa840ecfe01e27d47fe7bab1b2e7b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed734c01d0232b0071efb8378c9fd69e90e90716a02fd03b4ed654df829d4546"
    sha256 cellar: :any_skip_relocation, monterey:       "2e346f32194fe88dd706c442198221302f82c4222c4de0abfb1f7fadc5ea2e2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f71b10373a4216c9b9b57f587b5afb9cfe8b9af6ddbb4bab091ce5748a022846"
    sha256 cellar: :any_skip_relocation, catalina:       "f16b8ea3d089cd75044cc589dbc6bf016421f5a7bd6f6f3d5400c70cc674725d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c30d893b87f85cfcc94c80a0ee906fc4a7c5bc6c85fea7be2a25fc47e2e76ee8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/internal/cli/cmd.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    bash_output = Utils.safe_popen_read(bin/"cilium", "completion", "bash")
    (bash_completion/"cilium").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"cilium", "completion", "zsh")
    (zsh_completion/"_cilium").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"cilium", "completion", "fish")
    (fish_completion/"cilium.fish").write fish_output
  end

  test do
    assert_match('Cluster name "" is not valid', shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
