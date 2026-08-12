class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.5.1",
      revision: "109ca7ca71139e514114499d294a492e7910a965"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfa1369c7e3f04753018ce40fe4984fdbf11ad7eac8ce0690bf282e4c1ba1a75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "987e768b953dc9e647743cee29650c36925497ba103d9223e77ebf6b2e11197e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d36181f22b5418d5e822b62e37b5571aa7aee364dd74266bcd99dff417e00b0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4808f3b3e3c5578c0356a67f91f9b34d9dce8bba12d04497661e72c4a875be9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71fd5465eb2374da5d5615c894e42fca28d906955d60b36bf83371bb1f9895d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29fb0739a3a0dc556f6aef6a28a74b2d4fe1a0d41f57beba5848e329cdfbfa97"
  end

  depends_on "corepack" => :build # requires newer `yarn`
  depends_on "go" => :build
  depends_on "node" => :build

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
    assert_match "argocd controls an Argo CD server",
      shell_output("#{bin}/argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    (testpath/"argocd-config").chmod 0600
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end
