class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.23",
      revision: "21ea2d79d20e1081e8db883a608fffa175372374"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d8da3c965c15f188f1521e843e64da281ca6ea2034c513ec9d622c8c9dc55bec"
    sha256 cellar: :any_skip_relocation, big_sur:       "4ace9380f09491f55c70415d89e06f91f7f038b800a7e4afd28b3919b8e364fc"
    sha256 cellar: :any_skip_relocation, catalina:      "4ca5d6b0b792e3546fc9a31c685fbc074ec04a1267afed540aaf1dff4c7bb248"
    sha256 cellar: :any_skip_relocation, mojave:        "221834df85a36d25b676829cb53aad34f48f3577e55ea25603545a9f9688b0fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afb4bd77d9f79138e08a4d719b7cf74198d0db8e178f1448751175703c4db12a"
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
