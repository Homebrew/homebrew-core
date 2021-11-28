class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.26",
      revision: "6e1b58a2490259995355eaf92a088aa295e3cc70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "129af0d3e6119b48822ea75928d1efd06c464a9ee9df2c77edf9bf9324662155"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b4bc238c9e9c4dcc67fcb2d89a3ae0d75f13bf74c32d7e998d5a5119558e4aa"
    sha256 cellar: :any_skip_relocation, monterey:       "6ebc1c80a5bbf5e9b2a84e702ab7727aab71d3aebe2f602399d5c00a376c28ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "c22f3faf82aafae6200f0cd2a139d9bd9c6c23914b739623b1bca20f1451a374"
    sha256 cellar: :any_skip_relocation, catalina:       "1e7b194e6ae51bbf629a48490144dfc5f4b11874962f3177a9e498bd4cb8202f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f93d1d87f9de5b4cd67095e532816aeaaee35107401023ff3ab52a5dd125eaf3"
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
