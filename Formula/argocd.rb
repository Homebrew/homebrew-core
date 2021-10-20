class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.1.5",
      revision: "a8a6fc8dda0e26bb1e0b893e270c1128038f5b0f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5f89c32d33d58da0a8efc9167c7b93ddcba392759418940d9536ac60ac78256a"
    sha256 cellar: :any_skip_relocation, big_sur:       "1987cfcbfac791d3af13b78bcd3173af69c27782b516df686ef4154e8cab957d"
    sha256 cellar: :any_skip_relocation, catalina:      "795cbdc7f5a9653fc8ae2745d4c295c580e7e87c752773f73709053e9972e3c4"
    sha256 cellar: :any_skip_relocation, mojave:        "b69a28245ff91753e472953a2aaa26c9be6bf3be99f2f313ee8211865111619d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38feac932942e62f0dfe92ba46a17ca6cf3bb8a1ceede59318a38b776d4b643e"
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
