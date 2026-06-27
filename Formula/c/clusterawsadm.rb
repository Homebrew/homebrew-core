class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.11.1",
      revision: "eaa4c99b64d76179cb37e465808f6f00360d0bcc"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81e21f418ab05d804dde862ea930e669cc62ed2cdf2f3206bfc28a9e8869c2d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b9c88f0b060271cf84ae7bfa49defb9cea77c700fd857dc34a1beb3cf9c7098"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de08d585b9d981b2ecb810bfeb2a57839062899b40710654e08ae14d52cd5171"
    sha256 cellar: :any_skip_relocation, sonoma:        "4725477a8c2cfb66e7c2b0c6d4df9c6f5ebe27ddc0a778482fc88ff05ec16807"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0cb385b67b34408439403b5531333d320b0e09141988a43059066d74b616aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7daa7d46370aba8d3bd6917a80a912e60799380a86d612109583c01b7da7ed18"
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
