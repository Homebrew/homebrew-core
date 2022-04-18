class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.3.5",
      revision: "a409d3417a52ff374922ec31af7e620540c5dc00"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e1cb6c5087c557517ba453574f91710ee9277dd8ce4c6cde1ee5ec7bd69e4d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e04834c08e5da164de91262d802ad1254cc2a61bf30e6e92a4d7f0f5dac14194"
    sha256 cellar: :any_skip_relocation, monterey:       "728fe749c8510ca43dddb624fc68188a0463d18518afa6782e488e6909e78b00"
    sha256 cellar: :any_skip_relocation, big_sur:        "061b60f91d9c1228edd1eb9f0c453f51f9d77bc7550f2fab8d1bfc6c2daaaa79"
    sha256 cellar: :any_skip_relocation, catalina:       "1404325aeb983dfe2266e8e485b9ab4d9a6a0f215d4279f60a8f3ba855e0bcf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24938489ef3085802c2efdae0582c4f31a3f599fab68fafbaf877afdabff8569"
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
