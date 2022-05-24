class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.23.2.tar.gz"
  sha256 "adfc507517295fa1c1289528459921abb3e8dad1c7f304f6cd2310382f37c3d0"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd50adb4a14ce4bc457cac9fb82bcf15bc41257f4e81a308ea0e7f7412afdc94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75544f9be0611590173e5260c41fd5520051ed52a6c6207800aa6a59e357031a"
    sha256 cellar: :any_skip_relocation, monterey:       "93b804034ba15c1a96a6bb90d32b64f6324f0d6595d3cec7c9c948cf9d1952f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "c718c1b2d3422ea2d3f63a4b5ca413749f6e374a8c6a75bd3a7f6c3e8099d0c8"
    sha256 cellar: :any_skip_relocation, catalina:       "991a8c5df8a99c00b3cb5a323b2514a1ed4ea2156924584ceee1fb7931842955"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37ed9eaa22de0c82eef0b93505d1a9acb5f615b7be69bd6e991b430bcc2fbfbb"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["VERSION"] = version unless build.head?
    ENV["GOPATH"] = buildpath
    kopspath = buildpath/"src/k8s.io/kops"
    kopspath.install Dir["*"]
    system "make", "-C", kopspath
    bin.install "bin/kops"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"kops", "completion", "bash")
    (bash_completion/"kops").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"kops", "completion", "zsh")
    (zsh_completion/"_kops").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"kops", "completion", "fish")
    (fish_completion/"kops.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}/kops validate cluster 2>&1", 1)
  end
end
