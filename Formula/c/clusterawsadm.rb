class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.6.1",
      revision: "6db1244a6aea9058cc0546dd7d2151fc2c624acc"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2f03793e96a832527b700adba6bbabcd0409241598defce80a70d2cb2f1bc054"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ea2f3f31b671072543b3fd72ab8d6b05e0eb833728858fbc52a069f2b73459b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82e1e38258d578301e562d38fb62649af26b036323de82a035135725b441f169"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e5d63e3231b61c826917a1c5bf4ab770c25e8ed082876037a6f32119962be52"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3825c60499e13819e291ea477acba7ac26f2367b378241ade56f921913a6292"
    sha256 cellar: :any_skip_relocation, ventura:        "cfed274b97c2296ee5ccb411ad74e4cf43be25f4d0c7bf4aea05fd07ae843327"
    sha256 cellar: :any_skip_relocation, monterey:       "bbf0a2f3df4207629dacfb5e8fdbda54d077d2a3c6341e02489142854bc4b487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9f72f0c4f20e1761413f6ccd43da6d95a5a35ffa08992b530ffde7c4d4adead"
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
