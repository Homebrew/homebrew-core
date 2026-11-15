class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.13.1",
      revision: "6883178c3a1f426ecf70bc7dcf3ed0f4189e21a6"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "12bb246ee0d1290bb2d60d929bd191121bc592d569c6205a2796503e6a34cc7f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d99be941e33c25667d2dd5dfa6325fe6cac950179246c0aa0662689e48779e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4826f2cd057fded5fd59e4e5e0fc8d47dc380bdd6095342a5a03cb421ee26210"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "87f85aefb2ed42e4e5fc87a7df938752577224b297ea6b3f0209b5bd3c6e3f52"
    sha256 cellar: :any,                 x86_64_linux:      "7bb7f78eeef7b9948d7ae70fe9757821c84657a22bd79ca5a2f868ab9749c6ce"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
