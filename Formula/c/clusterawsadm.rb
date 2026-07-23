class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.12.1",
      revision: "13af0663710aa1f0c59575ec86e241afa4994f73"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b7d125ec04cfbd223d8311c8ea033dae26667d6305579add43fd7ebee992279"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4a6f682a623dcf4967cbff6d51cfcbbe707a5ba302ee417ce7de28458313d76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4343cb76c360b70e72929ee5b1edf8f1352d2a4f7271669202f6069c3a6b8f08"
    sha256 cellar: :any_skip_relocation, sonoma:        "e60aa62810a83e064ca296986a921fb87bdd5a25bc218b81e3fef7143e381b5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "169d606877d8c0bffcbf212a7f0b28170c1f39f94a56e2ce57ccc186d2d7df9b"
    sha256 cellar: :any,                 x86_64_linux:  "401d9bedf745ffe7f6287e5823cbbc8e7590d39e6e3beeec6648dd7ea9bc24da"
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
