class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.24",
      revision: "442e6c2dd70b093aa860b49de3626916107b9824"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6eb2ecdd7846092bf312c0dab8259886f7ad3c45b11c80ce1ec106eae0a63203"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1061392ccc083aac4c58bcdfbe679f869971deb7443104b8f97f529a9aa78bd2"
    sha256 cellar: :any_skip_relocation, monterey:       "33fe59edebce64ebc24cf29ebaedfeb462f761e7171b616a130d48d75b25db3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b39e57d996bce80f2212223b344ceaf8dedaf018cad707a505def051f9d1804"
    sha256 cellar: :any_skip_relocation, catalina:       "7577531b6d6fcff7ae83a8e71bfc4a22e18dc3ac284ec2c75c6e11b307d6629d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5fe76d446ac20ac6182387144aee43218ba9655a07ae6fd9b25dacec02ccdd0"
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
