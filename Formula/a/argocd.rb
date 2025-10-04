class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.1.8",
      revision: "becb020064fe9be5381bf6e5818ff8587ca8f377"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db8acd7ceb3c778e20420e2e5cdb098895ea793ca081c44f457d958c2f1c1bc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cb371e0e9f0a46d114422c3096af2dc5c6823c1c9cf6416b0d9cb1d13aaf7d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fe3db1dd902b862b3ab7a62db0fb65995e7dce3e8e0dcb09cd116700f8b8c40"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8e8bba5c89b182f6eaa265ee53e35b3473d1c519c553c293601f580f91ae610"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "094fefdfe5a4caf91c45327d9c4a6019e21418c6d04a4befa75dd6805a173fce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "676b7ab5b02ffb9e7aeb77d329eeff189a8b3c0a17a3313507f579b0f8ea9b44"
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
