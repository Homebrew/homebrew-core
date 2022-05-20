class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/archive/v2.0.154.tar.gz"
  sha256 "4aee9971ebf2ffd6808ee2991b38393e52331ce5f0706060e824ed215046437b"
  license "Apache-2.0"
  head "https://github.com/armosec/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce115442e547690fa873bdc2b54dbfc4a52bf229cb311ec5a6c1af40aeebecb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1294b4daf74fa594b4c5e1eaab15035327e5f3f791fb10ff67193c66283c1c19"
    sha256 cellar: :any_skip_relocation, monterey:       "a034f15f4da84aea6e3530d480f6a12351fa97572efdddf391078fdc49cdf5c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "08286d9b5a0d00bd543ad8053e66747cc669f99f4180dc8208512da3373e8621"
    sha256 cellar: :any_skip_relocation, catalina:       "a022dde3f49ceceb4c4c5bb2621eab7448a00f977d2148102647c492e88b968f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "399e0b1413f18beba18b538ff59df18c1615b738517892a4ffc20f4c099ea79d"
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
