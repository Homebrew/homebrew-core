class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/archive/v2.0.150.tar.gz"
  sha256 "af6dcda929ab46087c1e1e0c03d05ea0c63189e3e9af97eddc13fe08752541b8"
  license "Apache-2.0"
  head "https://github.com/armosec/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad20c746813c4fdab9ecefb4ad2c918532d95d6feccb08f4a4b7c2b6a94c81cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f24c7464a6fb5ec7c760c5a638aec89e69e6cb2bd167f74512f0272580f6e47"
    sha256 cellar: :any_skip_relocation, monterey:       "45941e331e0de3bdcaacb13d8c358539f9509cd4d1dbdb220b5a8c39e414625d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa8155e89f78595d0a31f072d77b8c4f4452cb6b7e6c80a9b00f322318803d3a"
    sha256 cellar: :any_skip_relocation, catalina:       "bda0911d979540e4777a3826ac5261dd44f6804728bb8ca8a400d878ee200ad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dee0b74785140c5acc9db7d7d5dd45d818010f1b2ebf9157af16492e639f957"
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
