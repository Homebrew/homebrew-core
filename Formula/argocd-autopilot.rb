class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.14",
      revision: "617c6e22ae674193ad120766959ef42d59a93037"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "46d3c23e5cbbcfbd4a87016f6b917776c0efb0b4bba938f29c70dfeb747f2397"
    sha256 cellar: :any_skip_relocation, big_sur:       "cbf2b7668e33e4427fda580a5ae94604ae2db7c68a2837dee107bc72fc3f939a"
    sha256 cellar: :any_skip_relocation, catalina:      "f581a6eec8a87c1c7fcabe9882c376091454a75f70177683e3fb280a785e7726"
    sha256 cellar: :any_skip_relocation, mojave:        "aa9f87f03a20d7118f6e56aafa123f91a1ffeec3a2c8db4b92422e110b4ea2f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "512577712169b08c408c0aaacfd09899430a0400ebce3fd12e3abf83ae016a51"
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
