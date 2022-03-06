class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.23.0.tar.gz"
  sha256 "752eb58feb0cb06d224b98d7fa23ac8fe9cd9ed0ffcd2706ab870bf1ad8c7d2a"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "735886aa8d506c5990fa1d6f4877c36aa92e7a08b0a30958c42e7778dd9ea135"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f9b764c6f4068f2d7724e08a095e163ab3cd06b2d58c7b492bf33e0aa9bbc95"
    sha256 cellar: :any_skip_relocation, monterey:       "57a499a615685db592dcbece4fb72f8df602facd259267fc407fd7679fb74921"
    sha256 cellar: :any_skip_relocation, big_sur:        "afee753a4576ce99e2659b192dad484e8d24c02675c0eca20e546c344e23e822"
    sha256 cellar: :any_skip_relocation, catalina:       "c48d0394429bc29ccb87a633fc66746ab6d147510217af622ef5b4cbd775af07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8d1b7bcee6d18cc2864b03c1b0e14bce2f7dd6bdb371027179a0be57b293303"
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
