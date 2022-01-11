class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.22.3.tar.gz"
  sha256 "76fb2e20f1d4d54904311c3aec2298ae99dcea5ea8473677a61f6e6c7418d341"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fe1943d71112f782c2454f1b3694a06603e98eb6451684bf7452066c8533272"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e62f2eb1836620e847c9351526dad54222e83c6cfb54fab4ddc5224aced6f839"
    sha256 cellar: :any_skip_relocation, monterey:       "ab5bdda358bc64ce1d52bcace39c730ba7114f98ceb7825d13abb4021db2e9f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3dec44c868ec0ad65086a33bb4c4aea6d94ac115f5c7ee61bf1296bd24db7eb"
    sha256 cellar: :any_skip_relocation, catalina:       "f0c842d8424346d52b05d72759a931062fb5151a55495b5281796f8ae7fef38c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d006913e830fe89f10abc0e3f87be4b40166923062723b5803a2011bfc1e337"
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
