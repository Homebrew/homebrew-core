class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "ebb54783c57e7997986dcc5a73f4f845015920b857dd348abd7a02e5d3af65ec"
  license "Apache-2.0"

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
