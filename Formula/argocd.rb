class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.7.6",
      revision: "00c914a948d9e8ad99be8bd82a368fbdeba12f88"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "831a5a43eb0b0ff3f165add84ffc5540e624ac4678c2faf59b1dc9e1c1711ba8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e330a0201800dabbe27c17904822010c0b6dc51e09b7db761798e5a75b8edc39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "582acca57c4a31ce133059b3e576d4af2f441dce8c90d8bff06f7568811bfa6c"
    sha256 cellar: :any_skip_relocation, ventura:        "53720ce0336707b6411cb1bcb3c77464e4f809e769698d091bd4984a713c707d"
    sha256 cellar: :any_skip_relocation, monterey:       "a3eebe6d68a53d21403c8eb5da4ebc0f8182ab153def9dcaeb1dcf899b9b99c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "44e451ba5066ce2f0aa37697a554ff6b3d3f6eadf9af6cd2f2df5dc72091a67a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a9d37279a106001e0e875eb2c68cf3f5e20fef60cd5560719721957fa329560"
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
