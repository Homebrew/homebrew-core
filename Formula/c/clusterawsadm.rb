class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.3.1",
      revision: "ca3cc2d63a5646c06d5dec5368ab7c50fe806ef9"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc4495722691f1cea61da390ac0fbf5cbff0316f5952b5be60752076b5ece110"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "928680dc298f7b7f5960f5a96d06e74374a4fa8c64e40bc5c9309ad32f6da066"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9396452bda0b052a59213371e3c3b9dc251842e9fff99cc2518b24b71e918ecf"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9cb33312181d17fd4d0930b11acf64519bfc29361634ff5c59514aaa3ac0c95"
    sha256 cellar: :any_skip_relocation, ventura:        "465867caffcdc7e06cc0330ab0f194c5d5088d7519ec53a009da3186add6e852"
    sha256 cellar: :any_skip_relocation, monterey:       "7c75b7bf3f4f812b34b1a44fb2808d1bc26a43eb382c3980e2163c17d2489972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf5c4990ddffc63b056589ee6c6f2b32db4d29efd80260edf981c94debb1a440"
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    system "make", "clusterawsadm"
    bin.install Dir["bin/*"]

    generate_completions_from_executable(bin/"clusterawsadm", "completion")
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config #{bin}/clusterawsadm resource list --region=us-east-1 2>&1", 1)
    assert_match "Error: required flag(s) \"cluster-name\" not set", output

    assert_match version.to_s, shell_output("#{bin}/clusterawsadm version")
  end
end
