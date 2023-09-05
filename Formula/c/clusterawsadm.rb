class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.2.1",
      revision: "4ca19b5a26051b87a2859ccdcf7feb370dd46403"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccfe02a5f50a1a2ad8a91c459bbb643c3f72271cc48051df28c8ee93fc30dfd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac02aacad22b052e3ec4e8f34bf1ffd794249362bbc02c6e531a0493d5b83121"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38b01a1d4a8e0a969c8d425858f070b28e301830b35ce1dbc69bd0eaeee5edcb"
    sha256 cellar: :any_skip_relocation, ventura:        "dc4b442961d6f082e98ba4242721b378183dbf323c3e6bf970657eccd46a95ec"
    sha256 cellar: :any_skip_relocation, monterey:       "5f5c253d6654b8970f5dc5f09d93b35250302b3fc76f9526d3629de008f6f148"
    sha256 cellar: :any_skip_relocation, big_sur:        "9db8348fd892e51ade4f31fa8b6cd9f4ac80b574064ad38a28b7ba0dd5813f86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e110b47604c544553272608617ac4096eb6324243b96d12042b74352d7db08e"
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
