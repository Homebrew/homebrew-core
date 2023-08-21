class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.8.0",
      revision: "804d4b8ca6bc4c2cf02c5c971aa923ec5b8623f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cac8b1eb73747e1ca686f8ce880fb8842f50de73338f3d7d6972bba78cd49dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92864d7bf933d943b6c653c9b94507578f45776d760adbc424a2e8ee0f9b3463"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28969d5ba72e451687b5663f04113cb9e6f5030b1b648afffc73768fbc5097d5"
    sha256 cellar: :any_skip_relocation, ventura:        "42c2f75193a70ee3f6549c830b1cd5311dca59e3d9b9eb09f4ea47357642cdcc"
    sha256 cellar: :any_skip_relocation, monterey:       "29ae83bdb8fb88b3926653a7ad3b57a944a0142418ed23db48a59605db8bc563"
    sha256 cellar: :any_skip_relocation, big_sur:        "49631fcd8c94e6be062b8536ef0fe574154e08b67c9b68a274936956d241641b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03769be29d7876b51ef9205bf3960a16a03ae2a4e482c3a351d977fb0fd6a861"
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
