class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.1.0",
      revision: "ece3399fa8e567ca1c8d6472fcc4f2a453e737cb"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d0eb585bebde45e41ba371b5f72429b8e7667775a6ff74268026d39ca0f34c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd4027ac1ae9742e996a37765b2b7586f9d5dc8ece51e34f9b77ac042bbceb50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a0b03982a776d0b31ca9c5f6857338dae661783e612c3a1420ff686297fce26"
    sha256 cellar: :any_skip_relocation, ventura:        "767560115a5f92b756dcc630035e4996407f63088c88b54764b60342d4d1f5e5"
    sha256 cellar: :any_skip_relocation, monterey:       "fe39040fde00841997b408a2d34244761eac00d89f9c2c004e1cefab206deee4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8ecfea7948eaaf4c1f63cbc6b2df6709fe215e0235cb70f6a0aed4cd7b01a35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fba51387516bb381813e0f3a707b87eddda1cf98ffe9de2daeb45d135e741704"
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

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
