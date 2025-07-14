class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.8.4",
      revision: "49658babd14cb9590f9fef8330243d530f7d6602"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "000bd6559e318952155c155d05548dba25f9ebafd15430b7a18c9a1456e6e683"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba21fff18a7d5e1560dfa16bc3a9e1656cffc2a43bef0df7c06c87af95c665b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b2391eb924d5c000c71d672c4acb98ebe509d8de968eae01bcd1d032ff13e33"
    sha256 cellar: :any_skip_relocation, sonoma:        "16d6de766e18a14f4503f894304c37433d796ce9cdf4e2fcb92ed51cac1d7dda"
    sha256 cellar: :any_skip_relocation, ventura:       "07fb08edbfec7f8165ae1e53db1f47aa3c1e02a2a92942f64a0afc76ea5eb075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea4f80b7a6751f98abcf6d57fd2b3089980fe1e3b6d138fec1cd95adba46975c"
  end

  depends_on "go" => :build

  def install
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
