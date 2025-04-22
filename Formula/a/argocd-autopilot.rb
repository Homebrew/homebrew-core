class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.19",
      revision: "5219caa2c688061b88ea5eee0aef9f97e3f62f25"
  license "Apache-2.0"
  head "https://github.com/argoproj-labs/argocd-autopilot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8f1cb49d25c8f73c078698833d5462a9162ce5233ce3795cf951b1e800976e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c18e73d1d74fc4408d3a1f22889710c4c470cab2f46435db86713d25dfea79a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86ecca72b084f402b6d72f5f659ae0bf100f1a8506dae55363f09ff809e2b65d"
    sha256 cellar: :any_skip_relocation, sonoma:        "58b12c996a20911d6174f8fc99fe919554a134f85e43d76f93c8791233dba4c3"
    sha256 cellar: :any_skip_relocation, ventura:       "5772f0f301054b0b0c204ead7da928d6788f7578e4c10e093899ba08489d9352"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edddade7e4b925030eec21764ec57a5728ea3af1ffa51bc973e4e10ccb2ae71b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c5886967e8b28bff08bf56c4d7d251ff2c7a7ac7dac38fa74561db77777ae93"
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
