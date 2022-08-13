class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.4",
      revision: "8f3d00fa40d89725da61cb1e6259fedcd75bfb27"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff1c12fea3dc55993bd5e3c452f4b2f3351e66a02f6ddd291a1f517d65b32ee1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c1383a9044dc3dd393211522b8e19794f391d1fc176bde3938d1ffc9b980065"
    sha256 cellar: :any_skip_relocation, monterey:       "a59afa04b6ef5f8647cfd51caf011d80d831d9b8322be1809247fbfd0e59d5a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a118f011776083b9caf1c73279034ef8072b95588bac85938877ac1aab88a8b6"
    sha256 cellar: :any_skip_relocation, catalina:       "0ac1964975b04f6579bc6ff905f8d9c9f6a8cdddc99cd9f41aed49353d4555bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e9132c88dccb5f4ff3d0c70d18fc9845dcc6d462be1ae34de41898cadb20273"
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
