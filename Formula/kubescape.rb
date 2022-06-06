class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/archive/v2.0.158.tar.gz"
  sha256 "616c047f3ac233e1555ee1ef97dd9a579fd9f700508f0cf17d123c4bfd146729"
  license "Apache-2.0"
  head "https://github.com/armosec/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8e8b3e8c79f7babe902fa1453f94cf4d8cc66f55227ad3c11f99e139b2bf348"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2dca68dd995fa83cc4befa5104e5425b1217d9de00d6beb74b02b01f42fada8"
    sha256 cellar: :any_skip_relocation, monterey:       "e3a8787b3bdcda79fd5b6a1a41dcf31e499c0a8824563ea7ae4cfc52c4898f6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a0a263e14e43e00d869ae59d5d7f95c1dcc5a133da4d6a27a7e842bec496b02"
    sha256 cellar: :any_skip_relocation, catalina:       "e4ce34ce335e76a51e43cbac421dc8b7408ccb8c9d2869409855138d1e5656e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57f8bc6811fb2834a906834a77ef833a5de0a4a71ce06a4a63651022cb6e1367"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/armosec/kubescape/v2/core/cautils.BuildNumber=v#{version}
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
