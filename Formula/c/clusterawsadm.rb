class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.9.2",
      revision: "d3a7da16f7a772ac412d1a37b345af8c55ddcd9d"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adaba1291b1c9e5e0ec72e380a906b43bc5d630d81ebbc373bc74a2f8ef8dbab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c9c6d3b573c851d0de7965795eab3363009c4b66a8ff3454a9d2e6048d18e3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba272bfd8d9c49bab7f15c7ad81be389a97581a98022478d5b372d67172ff84d"
    sha256 cellar: :any_skip_relocation, sonoma:        "afceea38832dc90112e6131b01cf0c0621d962bee11bcb0852d445556c3153f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5b8045c30f9a8b773f355657010b1e8c0af01dada71e2767b28405600662e9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "deb6230d326662e3d8cb0f05fae6a8be9f5bc5ae93c258b2a85e011cc8c890b4"
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
