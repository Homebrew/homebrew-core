class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.1.6",
      revision: "96797ba84644b2b182f48d11075771c93f44b42a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2630383c40aecac90375393c917e64a7b45ea2460c0ddb9a8bf66cca50b3103b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1788d16ac20d32955ab439eaa497bfe06b407d2a237fdb7c97e6f073996ab69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5704b85f2a7324a8a476907d8e82d22c9272d776a952fc74cb455bc545e6fd85"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e2112773ea8419ac2a8a25a32687c4ffbde4a9c7d8cae6e9247a5b0738894cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd4ebc6f675b2a4f8df00cc5cfbc080e40ba098b4ffd64b2003096b510940ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98a54ebfe3792a53ee4bec1aafa716817655ee3fb3f8419cd214a7d36d3d422d"
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
