class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.3.1",
      revision: "4246478fc6d9472199b33146fe52ccb4d7825a52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9366f6b56026d91dbc824b2c9a54177c5e46dad03e2e2615f5496cfca5d52c49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2dfa353d05bd14ef47fe982fc7661cebbff45d503779c2ebd55122b477694d0"
    sha256 cellar: :any_skip_relocation, monterey:       "a6bd0513edf23e1dd9b321fcf036ad3b6ba4638b5822f3e55fb6537e7f350d44"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f0c62a16f0f5e6d472befc7638f3049edf740c73a9e44cebbde0fe8ea8a1346"
    sha256 cellar: :any_skip_relocation, catalina:       "18eca167f7e339e6df91de47c74680f0e44a99e430810e28aad5fb7c73f6fcb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c99efef42cd78272b720c2adef0c2452acb60f51ba8b59f6406bb830146ae81d"
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
