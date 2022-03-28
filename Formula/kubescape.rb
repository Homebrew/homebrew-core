class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/archive/v2.0.150.tar.gz"
  sha256 "af6dcda929ab46087c1e1e0c03d05ea0c63189e3e9af97eddc13fe08752541b8"
  license "Apache-2.0"
  head "https://github.com/armosec/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3028b98618616a19367060d2a0db49cb86d22566be3266b0fe4fabb911361a29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c1027f1d6e1185232b8afc256f26fd5c5ad3c30596f73d2ecbfddf4d0db45d5"
    sha256 cellar: :any_skip_relocation, monterey:       "fd902604e65a755f2b9bdadf2f4d2c67152613979ccaa381f2ccaad5d1b8a520"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cac59fdbd8ef6894eff5bab5b0b4086837350e771d4d86cb18c6fb972fe89fd"
    sha256 cellar: :any_skip_relocation, catalina:       "c61c7cec44760b9b1fb369dbc08837b3f6905a47398f747ed07654b83b03e162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "762723b1d4624f3c186a814befa3f8bf44d9beb872c2ce918203e4286077bd18"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/armosec/kubescape/core/cautils.BuildNumber=v#{version}
    ]
    cd "cmd" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

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
