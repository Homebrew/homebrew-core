class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "7d4adfc511206af56570ba90dd523bd31f1703c8f9b36bca90e4d0863dd06ab7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b402009dc643fde2756a0b86b6553a5d76f3ad1c34c72248920c1f7539ce9681"
    sha256 cellar: :any_skip_relocation, big_sur:       "694b6f5f58bbc16220c4d53bc8aee5fb8f1ccd0e55c91e3a720856c695d97155"
    sha256 cellar: :any_skip_relocation, catalina:      "32c3bec63083873df4d1cc0921c7d31ff1846daf7e714ed6a62c56283dfc0a87"
    sha256 cellar: :any_skip_relocation, mojave:        "f11604cc3f64ef66d0598cbd9f9c9433d8db51aeefae292926ea5ab28c7518ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb4784d82d170b1ed14058a8b829f094f0f870fe05424af32ef42985882abac4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/internal/cli/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "-o", "#{bin}/cilium", "./cmd/cilium"

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
