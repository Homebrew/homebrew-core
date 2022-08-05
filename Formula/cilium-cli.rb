class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "8bba3eadd2ddde5b308f89302e53c37301dbac9131e1e1dedb86fe224556f4a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa20511fcdd4e2e0a2a8c0bd05af467cd2b34241d3d3511502e81cde3c6b00d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4748200e2acc7b1526369e56807c8d013f5420d32005b67db8bfe10698ca1b5"
    sha256 cellar: :any_skip_relocation, monterey:       "4abaa494da9ba5c193fb4665c754108db60e26d0553759ebeb6a606a958cdee6"
    sha256 cellar: :any_skip_relocation, big_sur:        "63f89ae1f1be37c55f3c9164d836431cfed5cef3e77f14da0f04d47117635a95"
    sha256 cellar: :any_skip_relocation, catalina:       "2243ab0e1b192ec34c60b702bbb61896eea78cface69a9263b75a64e10357bae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba1d67c599ec78d9900358787356e54c2b365e5d56d948a0d1994acdc23bb84c"
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
