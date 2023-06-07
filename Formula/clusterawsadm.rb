class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.1.4",
      revision: "afe04026493a4b41e2adfb4683e222f47f776489"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b521078f9aeb584ed22b651e1cd273ca4368b13cd38b1b907f41e6e9cd711e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0fae77fe3628067da6db279235f21e021d4c9bd822528a4c87ea4007e5dfa03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b3c42e07bbd7fa752bd053f4c5558786c410a8f567f7fdc5982051ba612e6f0"
    sha256 cellar: :any_skip_relocation, ventura:        "53d128c46c7122a860a36237f400381ac874ad487024f443bbbce9e170db45a9"
    sha256 cellar: :any_skip_relocation, monterey:       "9428914806fb9831dfe225700d7cd216f292f7a9fe7c318715be37dc39422241"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2ddae029b7a1acbbd6e9987434634f829a5c4b834e83729c7cfc2393818efc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2a7bf7158ff6e598973d42654c6d4f210226a6418b47d6d43bc8837647c2d53"
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
