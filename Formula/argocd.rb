class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.6.0",
      revision: "acc554f3d99010e0353b498a595844b30090556f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc3fc01df2ea23ba56c4748a52bc09910d577428d6b3821e76d5b4575bf65c98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "801cc01116ba3eee3dc451c7dc60c2170bb96ee2ae2a0a5ff4975fba344d5517"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3319ec8edbfd1015226db3b45f5be41e7179dedf16788d5b087afc1fe71aaaa"
    sha256 cellar: :any_skip_relocation, ventura:        "31e0d1e817512238283732634a5c1004086ddfe17d4bcd17c0a1179a40adc655"
    sha256 cellar: :any_skip_relocation, monterey:       "ecc4ee3c61d8baa7df61c92703bea599a889f47c9eac8da184e23a0d0be165c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0077fc3b685cb469b5af8aaa5ae071e9bd61cc5cf8eb6bec32c1368bbe24c968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab9571cbea359f64f5a8a21ce15fce8e79f21793819fea996910935f9c853bff"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    system "make", "dep-ui-local"
    with_env(
      NODE_ENV:        "production",
      NODE_ONLINE_ENV: "online",
    ) do
      system "yarn", "--cwd", "ui", "build"
    end
    system "make", "cli-local"
    bin.install "dist/argocd"

    generate_completions_from_executable(bin/"argocd", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "argocd controls a Argo CD server",
      shell_output("#{bin}/argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    (testpath/"argocd-config").chmod 0600
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end
