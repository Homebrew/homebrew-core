class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.10.0",
      revision: "175074f222a2984ec569ab743fd352e6683b27cf"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1efc88576eb2aeb8550ae8b0f80581562879a31c0c9a10ecc13a9a7cdf8f689f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8c6afd16a182d88113af661e4d3b0ae2fa4abf7783d3553cec341624c45cd23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42d53101223b46b267d4c76594c0b251ec31be6d79e20c558ad508c13b680ab4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ded8fbddb7fd4715741ee45abb7b2d8bc85ef18f895dfeb524489a290656c5d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25cef8c09625d0dfdda1519117c89ef1bc2a3a8727934ad9185916854fdb8cd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4465ab5739556ea147170d6ac1815f49e1d1b2262bb9d945b1e6b049eee3bedc"
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
