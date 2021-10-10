class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.22",
      revision: "addc155ba3cd39271357cc997e841df2a77aebc2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fe7ff5cd56051f77ef973679a439e0585cf1125928a5ff54ce5472fe43c114a7"
    sha256 cellar: :any_skip_relocation, big_sur:       "f8484e9312613a7ea9d3876d8d83ef3314f551607fa869c2dcd5acdf764b5cfb"
    sha256 cellar: :any_skip_relocation, catalina:      "030613b4c39f27af70e484850e9e466907e8239eb8ac854cb9ddc729ab18f74e"
    sha256 cellar: :any_skip_relocation, mojave:        "9e20ea628947478bce128d996a766ad0cf2bc8f1a82804b9999bd7dd8110aa4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4917e580ec75549c899bc0629c779763f1ea460db8a0861fb64f03214f3c7273"
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
