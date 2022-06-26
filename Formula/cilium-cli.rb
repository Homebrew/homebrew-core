class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.11.10.tar.gz"
  sha256 "c0cfaa3c2cb17ba085faf4f07176f0a6cea639f0f5e64ff1c5e89ceccc79cf9c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86c547535102c36b175e8de6c6cc21c1743a878ba77bea35e87454a075659946"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9693ef5f24322d96d25bcd4981c651d679903f3f3488bf84ebc690cec867210"
    sha256 cellar: :any_skip_relocation, monterey:       "bde2ad49fbf1b8197b3c58943fb97bc38663a1c0da76084b2e082c4da08bfd71"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7f1883934e6900db3b09041ee7fc295abcf67a2583d39faa55bc13f6da7298c"
    sha256 cellar: :any_skip_relocation, catalina:       "f55bd6b488e27fd63ad95803bea95517892c826b29c30ea55b318be726e5c303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "079c48ecb5484140857adba3113671c09ad77081525f177caf020bce3dfbda9d"
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
