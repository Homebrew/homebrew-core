class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/archive/v2.0.148.tar.gz"
  sha256 "33dc881c329739d0fbc45fb41ef4c5ac582dd02fc72147fd287cc3287b10c36e"
  license "Apache-2.0"
  head "https://github.com/armosec/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7d071817a14562732e372ff4a02f33d6d175aac8e391f9999b8426b3a45a1e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34a6d8703fff7208d4a25c5f4419da9730bf5c84f2fcefd2744ce382795678a8"
    sha256 cellar: :any_skip_relocation, monterey:       "92cc4db407f884eec73eb4458112ea058bb7850274640387ebd92f2689140c7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "61916e1e73b10bcb30f1306b18ae1ce4b7a29d899f3fcc6affa8e7edebed77b8"
    sha256 cellar: :any_skip_relocation, catalina:       "38160b961e111c3c9172868ec52d6a538ec2977e22d65561198e655f928de218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fac9da36ab2a334f5c854f2fc7bd2f846a01d7d1179ca35b52b4557b8e83e8bc"
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
