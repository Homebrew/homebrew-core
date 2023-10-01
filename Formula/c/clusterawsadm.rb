class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.2.2",
      revision: "46e6fb1090b5a42f12a2bf2469c7691127c2dfec"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d93a59f022eb9a14027f1784591044ad53585ccc97b2927f5dba4be1e975142"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4edad79154f69e0ab23045b2cb4906d6c1326840b6965843840ee26098dcd5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c283ad28a6cfad24194f221c50839deee9f9edeb3c872e919e6398f96ceecbc4"
    sha256 cellar: :any_skip_relocation, ventura:        "30bfd23528bb08b0b42b9581e424782d6422790d453f6a353e45d6a7f26bda08"
    sha256 cellar: :any_skip_relocation, monterey:       "9aea7c2dd66ed285d11d3211fec99a175ea433cbf3949ddc1e1ac5413de3abe1"
    sha256 cellar: :any_skip_relocation, big_sur:        "90fa2866f2e6e5c41b51d04b958652183387b7844ff5017e824ef743b9c10d92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf5798d8b969f09b0d93924ab5ea951f5017ba77f99f06e4f42731fdfeaec1a2"
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
