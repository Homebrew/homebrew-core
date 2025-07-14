class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.0.11",
      revision: "240a1833c0f3ce73078575d692146673e69b6990"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3535a5b6efa7e73148f8fa6457de4354a2a97c6c530078ee52beb57f9263ef9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6266f06cd74c3626bef8699636e782d8d659335c91ab95ff15d9e26d9c541f25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "226d13f6ce8c404b0cd953eb8e858d93b074894ec784fb6c7dc7b3305bdbd8a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "86cf6b62bf04b783b4786600c0ff9522579c988fb67cfbc39c7607204a4682e6"
    sha256 cellar: :any_skip_relocation, ventura:       "6936283871f912ec98c04a01812b50630674887fbf190c8c64df343dc7ad448d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e176c1af022392823dac898d001c421c38c1072c830c24b633269ce65a4765c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06b165b1108efa29bd0f9f16564d9df43d111055fcbdfb22e89c5e61d572cb9f"
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
