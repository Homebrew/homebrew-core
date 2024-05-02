class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.5.0",
      revision: "fb221b14d1a1d7c16a749a1db1c32c210120a14b"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b98dd260ff4e5dea133986ecccf4e7640f0d49bf950c5ffb36b2fe50b884082"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "732901a5b2c9fa51d4e3ee2f893e94ef1f0cc8ed803b2913e707dce5affe80de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75b38924c589e1d8f877b090e9c886ee577cef4a87e477dc582b8ae5d0e553b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "eef731676f7f1cd782482933ee9d251cfb7e76259c81bf3036066d79c763e8eb"
    sha256 cellar: :any_skip_relocation, ventura:        "08c4e62f1570b10dc74adb350facbae3a0bab6abe62e8597dddb580f6881f6c3"
    sha256 cellar: :any_skip_relocation, monterey:       "b9125861e4de2d5f291fc1bd73aa06b8b7893fecca836632389f495015f4d285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "489748ecfbd436637c61e5036908b153ebc0d371497960af0225efcac05180da"
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
