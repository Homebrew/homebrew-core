class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "4de209eb1cb54eb764efd4569b2fa59a4a92ef5c86055eff90805dad7a0dde6f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96ee50ebdf0b2c30e32d0592525f4a2cf3df70fadce4cb364e3f7f32d678e283"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2389500d861bcb47df9b7c5a159f686bb1ae52261de7e9ead299b98eb48f1464"
    sha256 cellar: :any_skip_relocation, monterey:       "6921898f83ac3f2cd4416b4ef7b7cd1abef57171f892b357540f173cf68ffe8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7401646b648ca09c7536c4f84391ee9ed5d6f2dd1a6f862d377a4566e35d1414"
    sha256 cellar: :any_skip_relocation, catalina:       "dcb62e2b92ad49850a6914ebf1e7325bc9256a4e6bf4c5a3cc37d0cf26f50718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4c8ee1f06b389c5d2a132cd8e42898abbe6723e537358999d8e0e492ed346aa"
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
