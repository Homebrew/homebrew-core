class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.14",
      revision: "e05103a478dbe7e36164a5f2198cd04673b27222"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b0e6b1f2bf42e802060a48abe116f16ee70f480af26a8f2b188266b13a0a8ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a717d8a58de73161d4734b2f83629c18daa0a226ebe3252dbbff8749e8a14654"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5036551bfb894147b0260ae515641b7a73d5e2acf37997c5fad07579bf3abeb2"
    sha256 cellar: :any_skip_relocation, ventura:        "361692d1d7987d37f8769d2f53fb8c2b15f23364e019c2f986432d2adba71e6f"
    sha256 cellar: :any_skip_relocation, monterey:       "4e1adaf7488a109d6db52a90b2fca307cdc7f89b415780e4d0f05289d4be6734"
    sha256 cellar: :any_skip_relocation, big_sur:        "63d2884b679d44f2dc1dc2ea8f5a2b1ba3bb5cd5ae9a4b8ca158cd5db6cd87ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "217aedb954f6c39ffd4270917bc6ac46fe85e77f7d693040e49afbf29828f19c"
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
