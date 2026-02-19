class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.3.1",
      revision: "326a1dbd6b9f061207f814049f88e73fd8880c55"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check releases instead of the Git
  # tags. Upstream maintains multiple major/minor versions and the "latest"
  # release may be for an older version, so we have to check multiple releases
  # to identify the highest version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e68cada9f66be6a3913b5c4a1f2ee05c6e8c592e3bb4b5688c61d63254baa74d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "debbb8c279e51d9fcda59a0af4f5043330855100680bf8fbe43b49c18eabdf6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5598b499bcbe155589a74e4ba20227ab677de4a217dbfa2bfd036cfa449667f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ca31f82a9b3b436555db306674837dc41141c60d13a3909a7c379867ce7b920"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29cd89b83e8c7c190a41fed481162b22e200abadb02cbd7d682a3efe0a346c17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef6ba3005c31227dd341d51a5a33b57c08881a1297f9258a0208cdd11a486e7d"
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
    system "make", "cli-local", "GIT_TAG=v#{version}"
    bin.install "dist/argocd"

    generate_completions_from_executable(bin/"argocd", "completion")
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
