class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.2.0",
      revision: "66b2f302d91a42cc151808da0eec0846bbe1062c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f0cca48e367e77082d62bc8f9814ae4d690d2abf86bde1bc3c033631d49fef2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "410d6beae4b0761a4f45ce396c3d3bc5dcf0a3fb196b5e4b31d7f8941b6b7ea6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4b019705f9e7c186813688a5db17bfe31dd102260318071c866723a330ea287"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc9c030bf7f0d0a45c147d061e03e847ade649def6a336981c36bd7788b262fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c65dd5e48621be5eb7f8f074693dc6005e29615c00022af13d4b5cf2cf39d41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5902d16c0f28b8ee22ad51677487704661729c1debf9f3d266d73f38293989d6"
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
