class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.10.2",
      revision: "999ac9ad1cf483469083fd599ab3ce89e1f6fbe4"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f92c24e53d1661fd010e6199291e737c8e1fa72183e8ab95b3722eb5eb291236"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0120ebc49a46c46f130ec0a07ad0be052bc01c2ea8a5722b53cad2226602472a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1eefc085a05472bfbcfd20003a884a2ef5b94cd2a9002f11743ff72db0d9a5ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "8251e5026c5f72d32f0f75014b82d28e91535990ec7c57d00842ac7de6643624"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a941298e0db7c32bdca8d4a713465acc2b07ecbe40ae3ea276bb9f9555f2321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bcab380e8e32a64350f9e7c1a55e95da25a42a4a59e6da9708807a080550655"
  end

  depends_on "go" => :build

  def install
    system "make", "clusterawsadm"
    bin.install Dir["bin/*"]

    generate_completions_from_executable(bin/"clusterawsadm", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config #{bin}/clusterawsadm resource list --region=us-east-1 2>&1", 1)
    assert_match "Error: required flag(s) \"cluster-name\" not set", output

    assert_match version.to_s, shell_output("#{bin}/clusterawsadm version")
  end
end
