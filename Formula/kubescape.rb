class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/archive/v2.0.152.tar.gz"
  sha256 "6132b81ebabcadca67fe87406f9be43d48af943f72af6217d80a41d14fbbcbe2"
  license "Apache-2.0"
  head "https://github.com/armosec/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3ba0088dc1a1455a4df3097d7f476f1fbd0e4e4b965ad9361b4d135ae27e978"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "280cd2ceda2639415526a6983b85d322fe71970b5424945e030eca4780a08e12"
    sha256 cellar: :any_skip_relocation, monterey:       "be4d846433c4953fc430acdee8dd3abbc0fb5fa726955e4ca61e967a3979018f"
    sha256 cellar: :any_skip_relocation, big_sur:        "22af5df5451a42332168e2d6157cc96a64619f654fd6cf812759db039e818ae5"
    sha256 cellar: :any_skip_relocation, catalina:       "d695bbd874ff667a342300ac55eaca8d953abce453b82b5090330ffd22e63dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b57b9a44f382cb1642ac4c8637a2fc17e1f371489ff60334c451f9caf354a4b2"
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
