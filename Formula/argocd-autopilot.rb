class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.3.8",
      revision: "ae714b11609835f5699fe6d3831cf5e3698ddf46"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1195c689fea72e415cb76d6a741180164cf378c7efd4005a0bd00620f9764076"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dcf644d4a7ccd8fb14e006fd35e4b48cdeddceda18538285d0c69cb6c78174a"
    sha256 cellar: :any_skip_relocation, monterey:       "6eecfdd36364100d772775981900e3df627703da19844ac12c5038d011ff27f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4e40d64656014adebbf0a3b0deac7d7a7272259f2342e8d102a510cedccdb00"
    sha256 cellar: :any_skip_relocation, catalina:       "9838025d4d7184924999948817ab35448ced16b36298f01a755e1d4d81c39998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9606a2e41777b361521b26466381baecad5dee7070f7ba70d39412eceda17b17"
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
