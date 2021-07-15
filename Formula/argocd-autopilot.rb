class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.10",
      revision: "bfd0a227cd3bfb03236ebb9b918ac175392f3882"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "259b71e820445b2c3ad9171807ed33c94d3ab78f513d7c253f8883495be128aa"
    sha256 cellar: :any_skip_relocation, big_sur:       "82441cb9df70b71984a36105de21fbb3e55d292f467d723fc560f89a1c3293b0"
    sha256 cellar: :any_skip_relocation, catalina:      "361af476778ddefe1b505bc5236abc805a08c9e234f30d7c50461700c5e92f20"
    sha256 cellar: :any_skip_relocation, mojave:        "73481fc46726bb632a4f6bad51ec4c4828b04069d3b23e8da9d2097c3916a1f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22260a578b40b38d1ccedde8b890a2c804f1dfe2bc3073ca6d77234131a2c721"
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
