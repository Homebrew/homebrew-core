class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.3.7",
      revision: "9ba4ca5f5b489bd8f30a3f017a745d2863af795b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a95be1ce70e932acb3bf902bcb2ad28487fef140db469b3441b97c22a1a6dc6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e40488c3d3a7e9cb7628d187f4f82f33ae413a986eb53851c54774f4b8a4cffa"
    sha256 cellar: :any_skip_relocation, monterey:       "556af6dbcba85597e672c10c403d6e5591cfdafca9df9550e940b2dabcb25e8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "14fba429a06ccdf9f394b0dcb8239273b9a2dd81cfd498b917c49fd07cf7f27f"
    sha256 cellar: :any_skip_relocation, catalina:       "4287e8262394c68d673c1fec9f4e9fb9b7f3e1a59b464cfc265bca0a853b4f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59af7cf711ec455d2fe2827bf44fa81ea3d8631ac8d6fad010f0c1288572dc22"
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
