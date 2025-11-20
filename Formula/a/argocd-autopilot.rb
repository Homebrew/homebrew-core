class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.20",
      revision: "a1d2d4c97c59d19127b1bfc1eca3149ca0984df9"
  license "Apache-2.0"
  head "https://github.com/argoproj-labs/argocd-autopilot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6413e513cbc1efeaad2aaf4afe34e8cdb1e2b38eff30197754f3c9d2fde65a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a030325b70b6a46c4d63136e638a852b25cfa90a871464f07724ea48951a7ccf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d34a4629f9d8089d89ca77a623618b73cb95c73afad228ffeb41a93ab021f067"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5899d7d38572a62a7aacf3fb9b30536b3e970c8ef910015ed25ba7fbcf3051b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4a677b34fea2ba9324961d0da07ed40374625388f6bdf7e43b3f3afc7a9de28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5c224d930f9df3fc46eae79c4d0c9e15339628a40e80bef6fa2ee2a1999a0ca"
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
