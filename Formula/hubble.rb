class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "e889d378a54986827927be01bc3875717ad84f5126773f345caf93aa0c57e8a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "113047c23ad679c1f20bc2677b8cf4b8358088847c669642d056b2560acfae5c"
    sha256 cellar: :any_skip_relocation, big_sur:       "6388ff464e1778aafb74b83fc86c7c812e971ccf67bf85cb9c54909c6a9242fd"
    sha256 cellar: :any_skip_relocation, catalina:      "10f774f91b48cd518944070f13668920948e62faf93340a10dc66f12bdda989c"
    sha256 cellar: :any_skip_relocation, mojave:        "10be5c09d955f9a54ab7f92742093906077df7c13ae54b7c0c72589bf16357a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c14ac1d48f9db3af7711eb16baba0f36de2adb5c748fbcf1684ddacf7232141b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/hubble/pkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_output = Utils.safe_popen_read(bin/"hubble", "completion", "bash")
    (bash_completion/"hubble").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"hubble", "completion", "zsh")
    (zsh_completion/"_hubble").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"hubble", "completion", "fish")
    (fish_completion/"hubble.fish").write fish_output
  end

  test do
    assert_match(/tls-allow-insecure:/, shell_output("#{bin}/hubble config get"))
  end
end
