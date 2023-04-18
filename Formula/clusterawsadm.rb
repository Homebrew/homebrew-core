class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.0.2",
      revision: "28bc9b8756d6d7f73038604038ddb3ccf4b22396"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5f784e2bce3bf83520ba1505c7d03e80c92a8db634342408d752989f0320e38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e721e228bd9d1512f5950bb05d666dc6f2169663f3328940bdbeecd6b81161cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7163cfd35f4327e98e110229c15ec8b4de608e7ed10c6d5d7b9f24fe366a8e54"
    sha256 cellar: :any_skip_relocation, ventura:        "3416aa9679b94721c5eb1eb83979e1975e2051fe9811d9dbfcfaccbbb5040173"
    sha256 cellar: :any_skip_relocation, monterey:       "459ef54405bd2e15487389b6756c16a9832f011ffb758798dfc460e5bc5ac98c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f76f25f3139c0904588b85683fdc1d0979d02e5e5cd941bdef16872a7ab757c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19d3cfe144245cf02af731b7140d9365005209b138f72a9b407be8fe6d24b541"
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
