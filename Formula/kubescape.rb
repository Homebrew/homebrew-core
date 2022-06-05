class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/archive/v2.0.157.tar.gz"
  sha256 "7e69b637fcc9110ce7f8d677485f329647ed51f42fcc6538af46cbb45ef60feb"
  license "Apache-2.0"
  head "https://github.com/armosec/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f4077968c31482fe2e08fb232dfbf47bd324ab4cad70f205fa81adca630c541"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b5562148b7bf2690d250077a5f9c1fd68c31b9d28caf11cee60b36d99e7105b"
    sha256 cellar: :any_skip_relocation, monterey:       "e167af9a6ed957bc4c4ad631b825072093c140484d26eb982aee0a4c55e755a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "f76ae509a69afe1479558ead8926d95b73e8ade4241b5ca6c03cc3d8bb2229ce"
    sha256 cellar: :any_skip_relocation, catalina:       "4110773a6012893fdb050335150f4673e96d57bba7e39da428e2446e649ccfdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52e2ef07124b3542c0a6072b1effbb6257b2755642a7ae6862a7b0e1429ca6e1"
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
