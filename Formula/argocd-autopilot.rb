class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.8",
      revision: "86be25e23cd660303e33cf8abed0dfb92a8bee49"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09bd852c436ddd24899090e9824c6ac53f1ccb2e469daa9238650160704220bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b27772fb22b8f61f560bbf9e08301637b5c90a5d01b2041fa5fbda6aec47f7d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d37589f6bf051c9329db7004d6292508ca8cc82cf2d08543dfc04466025414b"
    sha256 cellar: :any_skip_relocation, monterey:       "c71cc02d16bca2fd781a4cc7d1c173c0de09ea07e348f13e3a5186cf0eff8078"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6c73422a2a4246cc063a8b3eda941af20972e6a73aa9ea4048b610b2f4cb644"
    sha256 cellar: :any_skip_relocation, catalina:       "b74013a19aa0b3dbc338615fbc6ad23a9fee3bb50c00c9b5f527a02ffacd3a85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69f4ecc366c0a82abfcb8f028f4cb0c88f415d443cd0c3f92a10420aa53046e0"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-package", "DEV_MODE=false"
    bin.install "dist/argocd-autopilot"

    generate_completions_from_executable(bin/"argocd-autopilot", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/argocd-autopilot version")

    assert_match "required flag(s) \\\"git-token\\\" not set\"",
      shell_output("#{bin}/argocd-autopilot repo bootstrap --repo https://github.com/example/repo 2>&1", 1)
  end
end
