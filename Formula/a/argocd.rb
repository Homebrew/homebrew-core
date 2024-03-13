class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.10.3",
      revision: "0fd6344537eb948cff602824a1d060421ceff40e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17ae6a8758bd3eda6586b827ba816f671eb62405f69312c82b9cab85c86ec598"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c3e0a3ef6bcfe702571dcaaad704ce863c5a1f18ce65d56ebe76df7a1c092d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c883a2b1d49a14346b13cca0dfbbf311dc1eae810f604cc9258fd5433d54b6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b29621dfa58b3259739015b01819525d935ef246691b4980d6adc3aa899a6a49"
    sha256 cellar: :any_skip_relocation, ventura:        "8637c6d89cd12e1cd805bf556f0dde7e91dadf139b6db942393d7879d5db95b0"
    sha256 cellar: :any_skip_relocation, monterey:       "d2dce186f2eb982b2adb87bbeacfd83ebb5afc1e23157477497bb3fd207ebb37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4ee3357c4fb09e2c7c1edddf7f87f2208eddd39601ef9b6856c5528db1f82d3"
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

    generate_completions_from_executable(bin/"argocd", "completion", shells: [:bash, :zsh])
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
