class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.3.6",
      revision: "52ac98b00e970b30343df8694fd119274a88c773"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a426cb0b958bf549173972852509104cc65a3805fc42ff0d4c8c9670f1d6941"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8e22867f48fee9d6828907b5f8531bb76ad716d4e5c07e415f34f4a1f753123"
    sha256 cellar: :any_skip_relocation, monterey:       "55f8685e43b2e8ff41bb046d163c68013bac9e518dca4fe630842c7e82598885"
    sha256 cellar: :any_skip_relocation, big_sur:        "8681d33fbd1880a4fae59b5cf888bd128dafb737c2e528cafa4f067315a78f1b"
    sha256 cellar: :any_skip_relocation, catalina:       "c7638afcdc99e058e96b3b056dbd341af99a1ae98fa11a08275c302394f0a329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbae0452adea8f29874a66f5df864f3b4ad97bbdef71da8657ca7aa0dd0fa4b6"
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
