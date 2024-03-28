class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.4.1",
      revision: "cbf531711d117b823c587622ba0e64b94d0fd314"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f866c464a184c50ef3b7afcd85a5902eed8fd6b1c158e7d98d8b9ec7aafbbe7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4cec679ea112579ef3ea52fbd57a8c1d9d93b4da2c5bd374a3aab318cf8f938"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb96e9c03efabd8b7df7321430fb377320cab56bf3a6fb0114f7abbfc7653bf0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec043edb56d0e0440d40fc8796e213e8c9ec79e73e9b1eea41e15f520bba4a61"
    sha256 cellar: :any_skip_relocation, ventura:        "09bb1ff843dfb7cd3613b4fd9261d9475c9f88466547be91b5abbe2fefc3f4a9"
    sha256 cellar: :any_skip_relocation, monterey:       "cdee90e141035a93fb85ca107429403853783864a63514d7d7580093bc3814a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c6a5cf6546ebb853fedf10f1d38e949925592f2eb0e2b94976b3359cdd92a42"
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
