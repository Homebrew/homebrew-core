class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/archive/v2.0.158.tar.gz"
  sha256 "616c047f3ac233e1555ee1ef97dd9a579fd9f700508f0cf17d123c4bfd146729"
  license "Apache-2.0"
  head "https://github.com/armosec/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02b5404ba37a5396bfa0d9693277db54ed1d0dc81f1ac406b359f8531d01c0cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d91e7e294077b8200b0f84120b8fb935bd479e0f5015fe36d1599162562cef7b"
    sha256 cellar: :any_skip_relocation, monterey:       "3e8f1a528f59bd649f02937ad5dc641cba824d5b1304071c827a6c59ea8cd7f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4a1a057c071b671d03322ba6147970fccec0a282d4b11584043f12367e693be"
    sha256 cellar: :any_skip_relocation, catalina:       "7d44428c35db443b5a72621903e7526fd3ba5ee206b74a27e15bfc0b134eae5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a103284b28c5cfdc46c217db358add2c78ff7156068373e4e887052f4c59dc1"
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
