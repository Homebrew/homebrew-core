class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.30",
      revision: "56243dd4afcc712093453f30f08ad67a68d0c16e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3407dbcd66ec401dabd68c8bbd74f47824ea9d144c31bc45bc6791c3dd247d2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "637394b9968cc2df6f609174ea0781edf6666bd963094ac106e3b292cac87a95"
    sha256 cellar: :any_skip_relocation, monterey:       "8baa761eef9761e048f6a30a1939c46059aed90a1b633f0d3f7059074dcf16c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "136318d25ec11739472e249e5b5c5a6463d2035bf3ce46bf31a5aaf0eaadf33d"
    sha256 cellar: :any_skip_relocation, catalina:       "3be568c2c596445b8ebb66cc15ee929094fb04b069a8363dbb31c1f356196302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8fcec16a4ebe605f94880ab6991d219f9229d4751de219c9b3cfa70bc0b2c3e"
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
