class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.7.1",
      revision: "54dfb1ababdb620143e6db7b397f79d9d6f4f922"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2ebad7f649cff95866c4d13bd09641f92d01562911c884e36d23ad49387649d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59a352edc9f2260d16f5729cfe6a8b2c1314b38778f3982998fb81f8d4b1adc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03038ae45981555a619e64bf906b2dbf96e26b1523fb6013891124ea04bee31b"
    sha256 cellar: :any_skip_relocation, sonoma:        "474a480b0b24e03ae75876b449a2aad0f0e7eed89bbcf1c8d28de5a18272bf5f"
    sha256 cellar: :any_skip_relocation, ventura:       "25d03400b2f3addadeac8f0f9953e5975863276be4c21d8ae2ce118f9aec1d39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1a1a06087b13499ee0ba6f780cef9590ddea93a31d8bc9b389f27a83205ec89"
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
