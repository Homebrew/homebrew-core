class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.6",
      revision: "e11f3030ec2eeb84cee39826c648d2ff7ad962d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "45bc7e86329e34e10d248707af246228e7722162011684203952fd781e6c56e3"
    sha256 cellar: :any_skip_relocation, big_sur:       "10c9e200f09c3ed331287aa4f1a95d43124da3a3ba9bb77e6faaf2da0616a76c"
    sha256 cellar: :any_skip_relocation, catalina:      "10558c5ab35910ed48e46168441278e0dd81e2f7fccb92ccff6873381abd5608"
    sha256 cellar: :any_skip_relocation, mojave:        "db6c0e4a0c6fca9031a3690fe4f8a9895a87866533cb1f23df42491e7c8c4bfe"
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
