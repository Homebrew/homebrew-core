class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.1.5",
      revision: "cfeed4910542c359f18537a6668d4671abd3813b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0fc081ea761f173b210c5995837c032e35aeb47b5b506cb69e6e9c0485ec5c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b428acd494423377e57b3365a58bf8cf92965ef00552e2429385a2e505749361"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a6312e725148fd5380d8b45c99686142b7a5d4bee34bf72f57a6cbd0e6d6fd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b32b28a2348ea11da4bc9b63b519d764cb38fa3aa888476b0bc73b22e2296c90"
    sha256 cellar: :any_skip_relocation, sonoma:        "44395dc6125f821015cf60210b48f9a335c662b41f0774b67f4ce2f4f155573d"
    sha256 cellar: :any_skip_relocation, ventura:       "de2b512fd4123b153d224be2160f65543f86f45291a0f870dbd5bbc59940d908"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1306a378d5b6cfa5ed9e0865211674ac883e2f059933fbbb5756aecaea97fb20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0de3f807baa59e5f8c9ef3825e70309596a57dbcf01361e67dcdca7a2cf92c8"
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
