class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.8.3",
      revision: "3cced5006823e4c4aa21d427cb3be3e8d99a1566"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41bb8e909c8aba446a6ae586e9afe0e6337118ff51f2f8a289a7007b7b851257"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b62396ddfb38bb7f3b004e94f7c7131431fbf4095c28196a38016808e49fdab5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f1ce88ad3ceecc5e93f64c4176e80422046b4fb5befedb368d70e90ee39c04d"
    sha256 cellar: :any_skip_relocation, sonoma:        "104c8d48635f4d3b0a15b4976006ec9c0dd8b1259343e873b3deba597c868d42"
    sha256 cellar: :any_skip_relocation, ventura:       "fb5f8dc2d32f63595d39bb220d2af0314925d5984786cb188ebf8d517e0175a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f221c6d02a6003f93f080a9b6711654a37d7200a1369e9a5760eaac73ffa5053"
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
