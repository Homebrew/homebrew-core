class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.6.1",
      revision: "3f143c9307f99a61bf7049a2b1c7194699a7c21b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd7185e55f7548c9544129fdcf73737dab1416e0b0d5aa47cc2d7d1eefa37e8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7316931fdd92131d303a60c1cac8191cfd39d5afdbe8f22f7f10fa2f3af87d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5121cbe0ceac7e9cafea8ca9a1cfab3a09889c301a351c2037eedfbf6df2ebc"
    sha256 cellar: :any_skip_relocation, ventura:        "f33597832d474786c16af6df05324785c146694d0aeea1ba41071378274a663c"
    sha256 cellar: :any_skip_relocation, monterey:       "cd9a8d30655302c29d694e2362f5099856bfc3b3fe481a2a812ff7c6d01c8fb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab01ba1d0ae4007cf45f6bd904321fe95f8b5109fc15713b08351494fb9da37b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a72a57cf2ebe53fa656be363ff7d965d69de5b3f8744f939cfc55786ffd04a17"
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
