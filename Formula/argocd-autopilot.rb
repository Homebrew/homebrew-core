class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.12",
      revision: "d0499b825e21ba2a458bfc7e4e4b94342d2dc832"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "02e1da913f69d74b581acd952c5dd2af10da7d768f9f2f6f94058cc9a3615067"
    sha256 cellar: :any_skip_relocation, big_sur:       "300e3e9cba4a9abc8bdfd268be439a3d2a57a89a565a0d546dee9843d1732622"
    sha256 cellar: :any_skip_relocation, catalina:      "8f26b9db0f069e75fc862edf84a0429083e217cddf4245519b4ed6ac87dd0559"
    sha256 cellar: :any_skip_relocation, mojave:        "018ca73c376331448f5cf4d731c7c19c449c639dceac35f954640fb6679b9f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4530342defe2e60decded7acfeecfb99b5cf91d9f86020089756719e9439858b"
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
