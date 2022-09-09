class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.6",
      revision: "534f514aedf439157aa1079e92b74ac6c0fb3991"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3692961d1c2e694299dd1036755bd170d71d292bef35b81ac10ce49d78b87364"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8de7be4965af377d7f0b9a69617cb932958273827d1409788348e8120e64739d"
    sha256 cellar: :any_skip_relocation, monterey:       "68145fbdd45527313a5dfd4a1f5f6c626a6a408e6be2f8f454774d2b6d762044"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7f8b5a915bb339ef51f8f376b455ce74bd51a7386736943c8f237bbecff9e8e"
    sha256 cellar: :any_skip_relocation, catalina:       "e03859725edcc51e55e52f105362ab3f488cf795e0aa01c675f010841a30adf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "088f820af0e6c774e5bc9fed4145c75828d22a335284a7a17ab9a8717f79fcac"
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
