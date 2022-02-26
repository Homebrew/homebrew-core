class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "2ba8158450f145fffd9f1a13bd9c3a6379671d68fa1a69fdac610c3f6cdf95bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01fc397fefe0872b656444ac5da939e02e4cf0cf112ea031b1a09ab400915513"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ede4863c4289f9d5bdbc10e5873a7a697e40beaf714c9f8547137be8275dcb8b"
    sha256 cellar: :any_skip_relocation, monterey:       "09d097b4d8dfb9cbf9f04eea04cfdb43fddabbb6812da461ca5e1d3a967c8242"
    sha256 cellar: :any_skip_relocation, big_sur:        "28075de7a74a3c01d0563f6f0e588bf92c106e1fc219d47e6e6c957340201c40"
    sha256 cellar: :any_skip_relocation, catalina:       "4e39bd20e975410291cad39a6e4a5fc41af5f62d441f41dc59643ac8c0e1f4c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "002639de66b3a04bb56cf96f39465a57755ea59a94b4cf79df630ff5cbcdb00a"
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
