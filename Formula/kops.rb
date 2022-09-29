class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.25.1.tar.gz"
  sha256 "0beb111374a6ee77bbd63f28668f2bd4698737123c5ac3cd9e4e52893195692f"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad72795fd03016584a965fdb9fac902fd38a9fa1f1bc3c8adcb1c1716005d534"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdc349683003f83f524f231daa88960bec491a758cb278e53ac7b670954751fa"
    sha256 cellar: :any_skip_relocation, monterey:       "e47bf5a36752c83977163a6143d5729bc896dd6e790788ef341eb28a21a964bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b30fb4cec5b8517079527a0c498c2f2dabe28c835e4d99b2054eb8cda238b1c"
    sha256 cellar: :any_skip_relocation, catalina:       "ca2c859fc3bace67c09204430a29a9fde47007900a7eddd54a53fb787186f2df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "204ae8bc4081131356a62bc02c166b97ebbeac5fa561157fc916eec35d2c8b73"
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
