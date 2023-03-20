class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.14",
      revision: "e05103a478dbe7e36164a5f2198cd04673b27222"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5dcd7d37c866441c6c559876d83663e2bd4bb94d08884b0966583408808ad68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9556629bdc3221e0957a45978a45fec6d65c4db581ab8c151b0387ce0aacd3f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e851bb266a0614c5918ade7bc5de5eb264ac520bf6f8b05b57816017a7a0580"
    sha256 cellar: :any_skip_relocation, ventura:        "077470bf3f843c1f39f2702e887406547ed1352fc42905769090d89eef9477bb"
    sha256 cellar: :any_skip_relocation, monterey:       "5087c76ffa63333a7b2f388ff63e6a99ee4c31581bccdc3e9d293b6d1a10fc94"
    sha256 cellar: :any_skip_relocation, big_sur:        "def796308598c845c1402c49eea5cd0da377bc9530a957e056ac653071aec5a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da4f5e4bee5b1d737796c445afc29d1ff3d48e1a802663336eb45a83430cf60d"
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
