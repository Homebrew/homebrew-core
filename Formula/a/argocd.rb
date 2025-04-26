class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.14.11",
      revision: "82831155c2c1873b3b5d19449bfa3970dab9ce24"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c1312a56bf5caa5d23e6edb7d23dc9cef2732bde3df6c0b31e7b60719d009a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa7c7a95fc7190416c4f1f362599266659a63e31dfcad9fb4b63b79734370569"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a0e8a9f92351f95d10253d673925ccc948b995fc90a9844c8575827f88a2d76"
    sha256 cellar: :any_skip_relocation, sonoma:        "4513929aaf34d7c3203e13a4c6b53bef5a635f7ff4df79f4fa61a65c1a63cda7"
    sha256 cellar: :any_skip_relocation, ventura:       "4f9531502bd937c03c34948239ab4c74c90634c7367c00eb8ecc6f9f7f6a3254"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2003c0a4bd8df633740bce44b9b7c756511f1f627c3234683a1cdbf5993a9e0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be84af9b5c96f7edd339154f6c3602d32c242d9e8b8d223dd0cf526081413f78"
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
