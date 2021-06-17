class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.6",
      revision: "e11f3030ec2eeb84cee39826c648d2ff7ad962d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b229e72c7a0c94b7a719854b093b03c80bb5a3af520392c4f2ff3640f8fb66f9"
    sha256 cellar: :any_skip_relocation, big_sur:       "182f5d730cd8ec83a411877b1a55ada04d5034d83b3fb89d8f517bdaa6338c38"
    sha256 cellar: :any_skip_relocation, catalina:      "17bb9fbe8eea16612ed937a5ecffb16da0d3db662254786e560d417065b85283"
    sha256 cellar: :any_skip_relocation, mojave:        "2cbc197a1b7a369862d34d60dd9f1070aa2bd268c2d983ac64095f2cf339215b"
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
