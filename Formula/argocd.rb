class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.2.2",
      revision: "03b17e0233e64787ffb5fcf65c740cc2a20822ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94ecf8637bda96c0f13a909378b65cca7b6cdd16e657aec06b07598eef938292"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a7fd9210b60edfea6c63e61906c5b27a85843882ce0bfdb32249024048547ad"
    sha256 cellar: :any_skip_relocation, monterey:       "1504ce9f102d5dc20b570902eb0377d746dd895a300c5198255b97ceda9fd5f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1a1c3291ce97c7c7ab51882a56d0496993fab7f18f00f4cb9190f8a964ff7b2"
    sha256 cellar: :any_skip_relocation, catalina:       "f972f7a1c7157a5b7bb09cf11803e387804f05f58c47e33e07a9de1ee0b5e4a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6ffba311da1b2100b28cd050002531e2b5a48fca26972425cc64a73ec28d599"
  end

  depends_on "go" => :build
  depends_on "node@14" => :build
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

    output = Utils.safe_popen_read("#{bin}/argocd", "completion", "bash")
    (bash_completion/"argocd").write output
    output = Utils.safe_popen_read("#{bin}/argocd", "completion", "zsh")
    (zsh_completion/"_argocd").write output
  end

  test do
    assert_match "argocd controls a Argo CD server",
      shell_output("#{bin}/argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end
