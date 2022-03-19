class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://argocd-vault-plugin.readthedocs.io"
  url "https://github.com/IBM/argocd-vault-plugin.git",
      tag:      "v1.10.0",
      revision: "2829a416984d4ee4f38e6e76d7a38d9dd4d49dda"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "100741aa02ca831e0673fa7460b68fbe965d00f0bc686910e1615e7694934a3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "100741aa02ca831e0673fa7460b68fbe965d00f0bc686910e1615e7694934a3b"
    sha256 cellar: :any_skip_relocation, monterey:       "d96facb6730d4458e6e9286b7d9e02bcc95cbeaec8955083c55225cfb0512568"
    sha256 cellar: :any_skip_relocation, big_sur:        "d96facb6730d4458e6e9286b7d9e02bcc95cbeaec8955083c55225cfb0512568"
    sha256 cellar: :any_skip_relocation, catalina:       "d96facb6730d4458e6e9286b7d9e02bcc95cbeaec8955083c55225cfb0512568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dde641eb95e32b9a48828a6336f5aeef1e4a4b2a21ccd4e65e60b303ea224a5"
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
