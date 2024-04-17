class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.4.2",
      revision: "1c230091ea3db600e08f57bde25c862b29827777"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4002deb59b4657e80153f9141f9d72b9f8c20e26ed3671dc0beb6e25a224ae1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb63287815c312421872ddf9f6b4f1f1994eb831d6c78e2a2baeb28472231719"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e67070da1994ed96b7568758344012f168e2ae3d3c803ad8d886e18a20ca6053"
    sha256 cellar: :any_skip_relocation, sonoma:         "8559299e876b1cc4320007f452733b49835314bd2b73dd029b741290a17de529"
    sha256 cellar: :any_skip_relocation, ventura:        "c10cef1873fe83555221339b7623b844f4f389254a944170d8c82cbb0b65d7cc"
    sha256 cellar: :any_skip_relocation, monterey:       "5583fbc38035be7d0ba38313e49d35bc36dfbd8b46a7e8bc3110a245a813523c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a3245675fc781467a9b9560166bca07436c2c0c48938624123f2fe56b47c93b"
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
