class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/archive/v2.0.149.tar.gz"
  sha256 "6a97eab6d41ea65216fa399c676337434783465bedf06ce8827ae1be939fccee"
  license "Apache-2.0"
  head "https://github.com/armosec/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c614412a4eca569f33702e96723669f82604db357ff3b13931efce7305a86ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66c8de2156a525ccf9172900af8f0ffa34b911815fcb2cfd6fb3ada1dacf5f1e"
    sha256 cellar: :any_skip_relocation, monterey:       "4accde3031c36b1c54191bc6404fe235f45ca4245ffb6c645a6efdbf9524780e"
    sha256 cellar: :any_skip_relocation, big_sur:        "de70944f5b3232b82f92327c702c7a6acf393d1d64a833cfb395c3790a3f9ba2"
    sha256 cellar: :any_skip_relocation, catalina:       "0d2e6b1de2c308c63e8a0fd47b7144f8564b8e1b2a7c696849cfdd3b9a81132d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bffb1adcf3c8ecd0a82c0535d46c6175f14a67fe1e43b5617b2b8ec1cb9ee5d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/armosec/kubescape/cautils.BuildNumber=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    output = Utils.safe_popen_read(bin/"kubescape", "completion", "bash")
    (bash_completion/"kubescape").write output
    output = Utils.safe_popen_read(bin/"kubescape", "completion", "zsh")
    (zsh_completion/"_kubescape").write output
    output = Utils.safe_popen_read(bin/"kubescape", "completion", "fish")
    (fish_completion/"kubescape.fish").write output
  end

  test do
    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/b8fe8900ca1da10c85c9a203d9832b2ee33cc85f/release/kubernetes-manifests.yaml"
    assert_match "FAILED RESOURCES", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
