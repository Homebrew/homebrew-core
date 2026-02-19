class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.10.1",
      revision: "fd1ef27e4da78d34f20a9a4fec444ae98cc07785"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61985795d17b0247c5510738e3a58308c15d6659e831f9c5edcdd5c3ad917e87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d9d211b3bd763e03fd785c228913f061ddbd43ad07b5116b8ea8617804cdd1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bed1d651d480d5c29578ef46a94fdcc970f12520fe1c2c8a43e8a026a926954e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cccb802f7887a76070ff2d8575b1ea536dc2162385962027bf7e94b9e3715bcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0053d92caabe654a1425f0d6e157aadaadbfd1427128ec5384587c41a4059fe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13d9bf4fc18ed72d56551e8d5bad35ca213c239f29e54558c0fd40a94ad72eca"
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
