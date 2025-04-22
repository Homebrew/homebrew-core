class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.8.2",
      revision: "79ae3d046454586dc5ababd1f45c9791fdb5bbc8"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "522691a47f0259553b8efbe3e4d9eaed15b3b494d11891b1bc146b5e94317e66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c7ded21106ff04a7acccb9bdfa5116c3baf79b157eb0010f0d847d3b9c118fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d72d4a2b48214e15e9fb7129af75dcdcec1a237d91c6dbbde6151ba12a027c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b51bf4f7a8bb7154ae0ac8ed24b554c8d1bd684a0bfe386201807dd56767d6ea"
    sha256 cellar: :any_skip_relocation, ventura:       "b4ee0e75527edf221443ebfb53a500d538ecae60d4b06959339657963ef44893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da73b7cf561faedfb17ec642a0adde6ab5dddedf4e289bfa663069e7875be537"
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
