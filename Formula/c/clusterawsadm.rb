class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.4.1",
      revision: "cbf531711d117b823c587622ba0e64b94d0fd314"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44a27bd2098d1bb5256602358bbed4957dbcb3b770ae3eda0f3985b918cd9c39"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b59ee3a8c66e5438b7e588507d67e3448b4a8d5335162d37d8cccdbbea0184a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b029b8a9b9b0de2232df9346dcb32fdc8e508191acc06cd7fda79fc935028e49"
    sha256 cellar: :any_skip_relocation, sonoma:         "9620cd2a1809b07787431184c161cc08a963318efc08c414c8bab53ea00012cb"
    sha256 cellar: :any_skip_relocation, ventura:        "439d888c3f48606dbcd62dfd57b2ef2ff739c969d1462afcaf4dfa990286c6df"
    sha256 cellar: :any_skip_relocation, monterey:       "356a5b62c64c9d85bb80f6c6c740e09c3b6347475a00a4358891410b322f82a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75688f26df0865eab0953fe3db5862f5e763c9d4546c7edf399e15109ded3b37"
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
