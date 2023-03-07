class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.6.4",
      revision: "7be094f38d06859b594b98eb75c7c70d39b80b1e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02f52d0ca0b61eb9e1c508e08e1d82bc40705e1305161dcecf71493db6e0ddb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24e6e0cca45db8fe1079c38ce1b6ef4f2b37025776a6bd4180e6c6f89ef98fb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a5013706bbc98a75536b295a696cb7b28c5748b08a3ea80a4543c9b3bc3ed1e"
    sha256 cellar: :any_skip_relocation, ventura:        "99ae3c33f4f624b145c3e53a341b948b05d7309eff44b5c3a7763e5b5b388561"
    sha256 cellar: :any_skip_relocation, monterey:       "c68faa2d6202254d29ff76a5afe3fc787ca599bfbe89c0a31643addee0c95405"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fcf258642125e51225cfb8f8730f89cdcfd86ee6e78c43f1fb6510ec96549e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "414c41aca9cfe28b750ff94717ea76662dcd00b1a3ad7f32925bca7cf1401462"
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
