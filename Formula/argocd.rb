class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.5.0",
      revision: "b895da457791d56f01522796a8c3cd0f583d5d91"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "684f7f1354afd8f75ab53a07ca1fbef2ca2e766ae711c47a4f4cf186f1077ba5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfad7aa80bc42776c72f672d2d58408226a7bd0fe4c1b142be8adf709bb6cef5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5fea5514c9da14b83f04c422203b15f946c05d69330276644e0de848c17288b"
    sha256 cellar: :any_skip_relocation, monterey:       "8f5b35a4bb4889f3a6ecd0dc574d68169c5a810667e4ba6623af91d7e5673730"
    sha256 cellar: :any_skip_relocation, big_sur:        "051aead39c814d788829a1400a8dc4b5fca6a1cf0bbfd593a33c5e4de6c64e77"
    sha256 cellar: :any_skip_relocation, catalina:       "f02ab1a2d91ce1d5d43b0964fe76874f9f32ade6e00d51a74dfe3f898eb1cd97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdd35c60b47122bdf808cd49a037b44a531e7b5b13b1e113fedd4fd2feb81056"
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
