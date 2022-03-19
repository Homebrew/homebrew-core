class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://argocd-vault-plugin.readthedocs.io"
  url "https://github.com/IBM/argocd-vault-plugin.git",
      tag:      "v1.10.0",
      revision: "2829a416984d4ee4f38e6e76d7a38d9dd4d49dda"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3513c8d64de449ddb06e46304d47e1e09dc319059babb4db02b6e95a36814d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3513c8d64de449ddb06e46304d47e1e09dc319059babb4db02b6e95a36814d8"
    sha256 cellar: :any_skip_relocation, monterey:       "a34a1f3e42679035bf3377bb6066be39303ce5fb1cbc7e9ff646ca13e1958e48"
    sha256 cellar: :any_skip_relocation, big_sur:        "a34a1f3e42679035bf3377bb6066be39303ce5fb1cbc7e9ff646ca13e1958e48"
    sha256 cellar: :any_skip_relocation, catalina:       "a34a1f3e42679035bf3377bb6066be39303ce5fb1cbc7e9ff646ca13e1958e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98688186e920611be136900b5450576feafacd9cc1b4cc5bbe674948c6121628"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/IBM/argocd-vault-plugin/version.Version=#{version}
      -X github.com/IBM/argocd-vault-plugin/version.BuildDate=#{time.iso8601}
      -X github.com/IBM/argocd-vault-plugin/version.CommitSHA=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match "This is a plugin to replace <placeholders> with Vault secrets",
      shell_output("#{bin}/argocd-vault-plugin --help")

    touch testpath/"empty.yaml"
    assert_match "Error: Must provide a supported Vault Type",
      shell_output("#{bin}/argocd-vault-plugin generate ./empty.yaml 2>&1", 1)
  end
end
