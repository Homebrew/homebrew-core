class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/refs/tags/v1.28.2.tar.gz"
  sha256 "5b4ae2b6eacb95778feda38825d28f23c380ded67763f17edaebcab008f2cace"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0aa61ceb151ec2fcda9af009da8caabdbfc71e0e62fac1deef7c4dcbc74ac486"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6022d366a472425093c40a64753042d30df313ebd8e85e1082aa210019b35b43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77b7ea9e72416cd819900100b0122ea3903bc9a5540cfbf5e8d22eac130d6e88"
    sha256 cellar: :any_skip_relocation, sonoma:         "136fd9eaac3b137be345d07ceb8529d528323c2bfa33666f310f9b89133415d5"
    sha256 cellar: :any_skip_relocation, ventura:        "3f4fb7d7729bd773da130ae42ebcf8c0dd58dd3b16946a13b1617747f45e4ee8"
    sha256 cellar: :any_skip_relocation, monterey:       "dbaaba9413ca6c5b9ad858d143fff336c2b9689e50fb9dcdeea76dcc472dbfe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ab8e70b399a8db27e198f9dfac53e80d68752924996f47d19f723549086961c"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X k8s.io/kops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "k8s.io/kops/cmd/kops"

    generate_completions_from_executable(bin/"kops", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}/kops validate cluster 2>&1", 1)
  end
end
