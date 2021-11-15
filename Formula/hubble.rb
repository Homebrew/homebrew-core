class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "e889d378a54986827927be01bc3875717ad84f5126773f345caf93aa0c57e8a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27608ae503eb9c34fddf6480b11bf5f925fc755446732d47a4bff9464bd0903a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d6dd5374a95d637215523f98f1e9c247ee6d61cc5174b95240a2321356c2894"
    sha256 cellar: :any_skip_relocation, monterey:       "70a2bb9ee9ed9c9919a4ae2fb1d347cfd14fb8cca46c100c405de93adb093ed6"
    sha256 cellar: :any_skip_relocation, big_sur:        "10554f689224ac17005e2acf60ae0f9447dd923251b2968df60d84eeec05bafc"
    sha256 cellar: :any_skip_relocation, catalina:       "8e7b69d7e5b51709b6c90820bd822d0faf6652166457ec831c12105f7aa47d2b"
    sha256 cellar: :any_skip_relocation, mojave:         "f4605e76aceb5aedd4fb2e51e8674a3d3c840852c068602d251e1b3c150dc45c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4089201813348a6d45aed60860889501fa43a56d5bea17831893e62a1bc50120"
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
