class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "ca11474ced97ea7958305cea3d6e80837580764d546874b1e997eb15fef86f74"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02eb6de131b21a0f488771ca986e64e3743315b8be1efd9f0f8f54d502f4dc3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf774f0ed7ff6bda1dc72ccfb13c4e7a9a31bfe37ea2bf8d74318e71896ff335"
    sha256 cellar: :any_skip_relocation, monterey:       "db0b69dfedf90dddb751642bfa059f37d52acfb8ca2f386edad53f63c011a52d"
    sha256 cellar: :any_skip_relocation, big_sur:        "512ea2b560a89d9eff2574a05130a817c22a13d6e2068cbcb18a4eab21eedfab"
    sha256 cellar: :any_skip_relocation, catalina:       "48a1785fa7b4b2e38c7d490779aa53fabd04768fea3242b23690809c58da6ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b69640bd4301be137e18dc160a9ff7588c1851d2309e15b620f2c57054f1ed7"
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
