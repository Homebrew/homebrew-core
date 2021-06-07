class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.0",
      revision: "2f8e88f4113b105f7505bb9ef61480cb775b749f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "73f752116012851ed069bb2e426592bbe139155ce85873e3f2a418c114b6c539"
    sha256 cellar: :any_skip_relocation, big_sur:       "85a22487dfcda0508d42baeb6a7b02b22b90f22840edb56c53ebf4c170131bd2"
    sha256 cellar: :any_skip_relocation, catalina:      "fa063a4f517173a24f4b281704bfba8e8e315f883e2ea29a4327e765e1a82556"
    sha256 cellar: :any_skip_relocation, mojave:        "822450d51563b456e85af678471423e701613b4f8bd9b2b4cb933df9f5ac4b40"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-package", "DEV_MODE=false"
    bin.install "dist/argocd-autopilot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/argocd-autopilot version")
    assert_match "authentication failed",
                 shell_output("#{bin}/argocd-autopilot repo create -o foo -n bar -t dummy 2>&1", 1)
  end
end
