class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.9.1",
      revision: "9c1704975705d44b74fa4a1dc3b9a37e6f4d95e2"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5023afa9397593c29f387a0d0fcc660abdadf370349655dc62668e797888f6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be5b3a26dec54d9d22b37691138ba818a090c8c7e795c1632ba7b2b33d43c3b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a60560f837122b6728a52e2e514195988545cac93e549ad919c2f8811bc6dffc"
    sha256 cellar: :any_skip_relocation, sonoma:        "32ca62afaaf72f78522f0207187f45c29863b3da949d869cedaae96d769148dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca6e3ec8292970b0bec3d42850c4a299b61aace904ab8a2e4cb699e8c9a9212b"
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
