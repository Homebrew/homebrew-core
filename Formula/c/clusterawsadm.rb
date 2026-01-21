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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcfa67441fcb063bcc8a32c50ba98b6b568df0cbb3a3bc575b313d4ab4133aec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99de2bb0e849f33ece980414f90341680580ae6799966ae638f69bef60b93ae1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b042e3e72aee33d204019778253ab63ca06cc6ae2a07b075f9d2f1678d4b8cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a3dd636de8ffc566d030b2145df7ddbc45b71c62bc4ece98bf6f8add406d7a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cde735b325d9de83a1772212af642e9f83e877f61fd880e03b7e183858c90765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "731c99329e7717d54255710599e2109d37c9458606f5b4da1c4fceaef6cd6703"
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
