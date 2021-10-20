class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.1.3",
      revision: "d855831540e51d8a90b1006d2eb9f49ab1b088af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e337874aae61a65b30458e3f87119d06e0568b322aa498f8dab8455f91aae0b6"
    sha256 cellar: :any_skip_relocation, big_sur:       "79bcde97445079129b63a4fbdaff547a51b9f95bcad5a417e3ba5632f6eb499c"
    sha256 cellar: :any_skip_relocation, catalina:      "7a912c7c4bd69e2d012cfd6b6c20d592c2f5293a1a3dff06d73441a1396e31e0"
    sha256 cellar: :any_skip_relocation, mojave:        "fdb647b2364fe9c5d7c983b8ff8388bcf9cafc32974919c1b5d120ebf1f08781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "499bfb056bef377ced13085274e7d4926a421e1215e0e3cb8c7d78d9ac84e46f"
  end

  depends_on "go" => :build
  depends_on "node@14" => :build
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

    output = Utils.safe_popen_read("#{bin}/argocd", "completion", "bash")
    (bash_completion/"argocd").write output
    output = Utils.safe_popen_read("#{bin}/argocd", "completion", "zsh")
    (zsh_completion/"_argocd").write output
  end

  test do
    assert_match "argocd controls a Argo CD server",
      shell_output("#{bin}/argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end
