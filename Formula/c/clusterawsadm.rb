class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.11.0",
      revision: "815a1b02310be2e6ad23cdafb62bf08b0b44f98a"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a4ac0ed19257bbc088be8d4e9570b8bb479b1fd0b3797fde298c97e8f2763d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b81e71f5263b78f06766f6604d13bbe19a49c661ee88b97c6e27551b4544e0c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c9eb652b2dbcaded2d2160ec4b91ab2dda8f5f94f1739bba0b4971099859a5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "44e4a264d717f615d5487e08f1058dde62630daeeb1eadf80651c29a7bdd5cf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "698eedc1961c4176fc989bc6a3fef80cd179e92644ab4af1d26e53ceae6bf163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31a5dcc9fb8deb4e4a762fe853babb9c5b6ac637a9401129f7d65f4852b68053"
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
