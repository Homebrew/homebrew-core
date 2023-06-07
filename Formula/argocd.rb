class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.7.4",
      revision: "a33baa301fe61b899dc8bbad9e554efbc77e0991"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c12a1c861f712ec1a34b692c49c3176bf09325058af45747b4d63d7da0fc27b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91af9dd8074c0b771ebf465e3c6b4e5503c53f003def1af707b1fdc06944b758"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b92cf7037b9b0d5b89bc78f80312b3fe790ea9ad89b5eabd9545229aee8af8fa"
    sha256 cellar: :any_skip_relocation, ventura:        "ac84ddf8f74a76874c3ee2ac44e1ddedc48c0d4ea4813d22d88a37064e68e6d7"
    sha256 cellar: :any_skip_relocation, monterey:       "35dbf41a7b70dc2b825096c4207cda99761f64bb78418b3c4bddb0df67e3133f"
    sha256 cellar: :any_skip_relocation, big_sur:        "49420c274833c072180c4acd4084f12cf65fa75c247c31840dfffce5bd6098d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5730ef3630a4126a8ba9da42861a4638f43497e5f669a90c33f839524884d306"
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
