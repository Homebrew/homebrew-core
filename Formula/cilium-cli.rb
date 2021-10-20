class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "5a4e0fb0c615f2af3f04550df327521c323026525d3f15da7b72a14ff9e5dab1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d6f60f2746a8ac9611aebd2d6b16fb5d4b0594208d21d327a5f2e6fdab7795f8"
    sha256 cellar: :any_skip_relocation, big_sur:       "d1f58448204e2cc792c6e8864ae8033b1f19a7efadbfe8751280e973f6759843"
    sha256 cellar: :any_skip_relocation, catalina:      "05a99a179f3287de0f53c84687c9f1919c0d05172682d86c122d471314c8533f"
    sha256 cellar: :any_skip_relocation, mojave:        "24722bc7957c2b87783694ff4bf436d46fa1c4447f878e04635ded8b8535eb18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ace8b86d74337b1badfbd14925363d5632de607bd08cd0ca3198636480edb818"
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
