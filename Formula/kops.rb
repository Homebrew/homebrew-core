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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f48947697a87dceac2344b74ace8db19f103e23a5f5e37f8fb142d499ccb9cb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08f7b1c79a8affde3ba8b0d0b09c3ef914901950cf36d73f406d6b1a53df90a7"
    sha256 cellar: :any_skip_relocation, monterey:       "4b05311ac08588338a8bc5d272e2c8de4187dc07232913cda739ba20983f3ad7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5dbfda54332f8b92db00e985e4283bca8908b3801ce3b7897ee0d16e4786d34e"
    sha256 cellar: :any_skip_relocation, catalina:       "87142ff111ca70b35d7f792fad613cd26f84617313b260929988fb90b8281110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9d8817d002c80ad8011a3e3ff9918f839470dfb5c2edc6bc7e1d15b1f0b93a3"
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
