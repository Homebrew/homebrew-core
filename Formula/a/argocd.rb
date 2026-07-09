class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.4.4",
      revision: "443415b5527ac55366e0760c93ef0e1abd0cf273"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f9a1c7a9b5bdb46b0ff3f49999c62639da6e97f894f8c999df28bcc3f487e4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5242f49fa2fb585bf358e65f9505ea9b7fa74e1a1612a584f022b2ea68f36957"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a5cfb12bc4084d2b6c40d9284e675ff2e8ed6e04a4abacde9b9ead51cb1221d"
    sha256 cellar: :any_skip_relocation, sonoma:        "06263c0e2b4adbcbad3a13e4c9098dadc7bb5a670722ef233eb7ea2ec1aa3d65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92e397311dbd71be060a9362adf07bda9860179c065ebe79f18d74351672c36b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "430ae4e4056c7125b96f77aaa353604c28c935e6102b4891d78564388cd8416e"
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
