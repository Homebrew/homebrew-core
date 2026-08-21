class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.13.0",
      revision: "a84670fca02690c9e644fadcbbbf967a6e6f89d6"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46049f8c8adde5685d4b09f436ae6604125bab1b013c5d677eec853d08a9eb80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84dc3e6d70a67fe418e5958442db320713bf20863744be0fc10c92a3e58a4383"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6583d38ded1b993c113f1dac3d6e183900a291b50b0bb4af475106c18c95105"
    sha256 cellar: :any_skip_relocation, sonoma:        "5708106d5d9722d19aa673a466ce549f23b6f59cbbcd64d3cdcc9f2d5310048c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22772f978a2d0f5a305cc08c38e167bba6e2ef3a271519a926ad8312737de137"
    sha256 cellar: :any,                 x86_64_linux:  "5cc393efc88ab2e9d11a4ca7222c64fb7e2bf608463d7eca86e2e842ed8d935c"
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
