class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.10",
      revision: "bfd0a227cd3bfb03236ebb9b918ac175392f3882"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "05118f95a85f2f3493d6a6e8e81149d3e3e8c81a4a6ef1548fe3ce4a1e9f97fe"
    sha256 cellar: :any_skip_relocation, big_sur:       "547f2cacb85b6a721488deceac55e3972d6668c650a6b2d9dec8fa7eb03bf788"
    sha256 cellar: :any_skip_relocation, catalina:      "1476386333f269e15f695265a3aacadf32d20180956f5c8b5b2cd699f9985113"
    sha256 cellar: :any_skip_relocation, mojave:        "56bc8d7b3474639e80a80ec09c56f0b4d00af96067295daae188840f187cc852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c60c14161771bd6b1eb411594168a98ab845da24a26742c5cb98920012942578"
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
