class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.4.3",
      revision: "1801122b4391cad4961301f787006dc9a88c2dd3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7eb72e903c95f4471a2d7ced15689e5a3b3fe25c56a9b8571e864db166eaac3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31dfceadabad77813e48fbbfa206b0ea8196628e6f84c49d8d926d37f980396f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbc8f2399c9848b38225aa081a001d46ce683266fe7b5f2c76d1a137874c2bd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "206a23315eccf74c58124022e69a51c59493670be2b7a05a6898e454a0350fa7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9fe2a66b2a8419ecdb59a75a0b4186901ff8af7164d6cb23a982c997623d83a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99b66b27545e5f2ea8a368adb1ea9519b366c7e6343da73243c33ffe29838b1b"
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
