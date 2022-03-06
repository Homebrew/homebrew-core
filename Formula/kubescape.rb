class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/archive/v2.0.149.tar.gz"
  sha256 "6a97eab6d41ea65216fa399c676337434783465bedf06ce8827ae1be939fccee"
  license "Apache-2.0"
  head "https://github.com/armosec/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bad98447da9d5d6c0a7e7d988a44d9587a7e5df339462ffa2a924b457c2f87e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19594159948506d6a5aa55e68aa55a4d5b9f83dd0627e95b58290a05b26eeda4"
    sha256 cellar: :any_skip_relocation, monterey:       "ee04507e40c8328664953a4ac0536aad5a22cc8c38995009c32fcb5b81f7a42a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8034b08d4eca7252bebf367fdc1c9d40cccd062633b8d79a0c1f4e8b70cf3b61"
    sha256 cellar: :any_skip_relocation, catalina:       "188a381653f4a83f0bec2a8e03e462f5a802686f3c83379dbdb4a2c9a4b10978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39b2234f5d9f8a37d82f27ad7f9f67adf67b6dc4cda636ad4839edc0a32c779c"
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
