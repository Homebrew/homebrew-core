class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/archive/v2.0.156.tar.gz"
  sha256 "de3cc415d4d935389bd1d26353fcc9dee99aa27c2a7bc04af59011a204f7e536"
  license "Apache-2.0"
  head "https://github.com/armosec/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f291e8d626e53647ed8398d72f018e00bbdfaeb597e334b96223b2045ab80604"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85f34a77ffcd2238f149ac6cb3f1f93b4400f31438e1e9327c3bed4b98abf32f"
    sha256 cellar: :any_skip_relocation, monterey:       "a1c64103e7a1c3db8579e45952c5da93d450fdcafb0c8a748cc5e132efacd4ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc26732cd38ab4a76925331e862bb5278f6d5bd06b13278b9d92d9df466f8de9"
    sha256 cellar: :any_skip_relocation, catalina:       "0814125f56323afda6a6028340f0a5865a3f087a156759162a05f6bc6abac3b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2486fc0283d64c2088cfe0d923009805379e7788081e9566752921c6dcf8f82b"
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
