class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.31",
      revision: "418f022e56949d70f5dc42957fcaa12f52e014ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e413a4a4619b82cdd89d10702a8ad128f160753008dfb5fca656eb3549646a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2e1f387ebe1529d47b1486dc638ff06513b9614363f45f5af30c866e8a9bab6"
    sha256 cellar: :any_skip_relocation, monterey:       "adfb969298888fb5f50ef69a088abdfb387106ca7f32684c8a62fcf66c9d6393"
    sha256 cellar: :any_skip_relocation, big_sur:        "459389d3c5ce556d03da70bcaa9fe8996530d68d52fb65161683d61c692f5475"
    sha256 cellar: :any_skip_relocation, catalina:       "3f78f70922e76641286404002ddf1e640f5218b5b859334f0e97bc9bed0c6110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "277a794a478c6b705df0b2755d4ada96fc4ca066f93bc1486a1b73f876aac09e"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-package", "DEV_MODE=false"
    bin.install "dist/argocd-autopilot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/argocd-autopilot version")

    assert_match "required flag(s) \\\"git-token\\\" not set\"",
      shell_output("#{bin}/argocd-autopilot repo bootstrap --repo https://github.com/example/repo 2>&1", 1)
  end
end
