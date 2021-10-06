class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.20",
      revision: "f804d223c348cb1bdd0d524f6bc4fb50c1ec3400"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8b006dfffd8f9eeb91c6b5248a0abaa0fb833f31f110a08bd9b0dab7e66f4b4f"
    sha256 cellar: :any_skip_relocation, big_sur:       "3929b49edd7fa879df27891ec843b612abd2f746fc8e91f3c7eb784076aa9769"
    sha256 cellar: :any_skip_relocation, catalina:      "18694443c8e0c1fb7c94faaef4adbba8d3dd07d9c82669c7ec251cad0dd6d2b3"
    sha256 cellar: :any_skip_relocation, mojave:        "447677471afdfe67aa20033848e1c8f8cb3a257e7df050db3483f70b533c9940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "240cc20b85c1f63d2c028a3c6416a96e042056e4f638675660a579e3840876a6"
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
