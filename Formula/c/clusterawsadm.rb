class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.2.4",
      revision: "56c9a39dd834640ee4a027e679ad2a5757098dfd"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d8bda45258345dc6ddb4e5e9e1137a2aefec989afac8565db66b93565df9e53"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9db1579c9d8f537a324f0c88f76a8b43f7ca08266571dbb33af5bc52a666b871"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1196f9567c2e36946f07b800ff0a23ed40c98dcee4a6fc572ad4a593f04061a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ff21775e0de4ae48faaee1d0f9d63cc1a5371b6abe752aff568626fef589995"
    sha256 cellar: :any_skip_relocation, ventura:        "0637a285128ed0b7dc802d52dd1744f9a4aeb326fdde07463e0bcbd74304f06e"
    sha256 cellar: :any_skip_relocation, monterey:       "d2812d9c09ae1554c095cb76933ef59f6ec2c21ef9ae2f249d5032a70d724adf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "646516f242dde05fbb2598a2d15a6bde1e7f715a83a04a2367755d8264ecbfed"
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
