class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://argocd-vault-plugin.readthedocs.io"
  url "https://github.com/argoproj-labs/argocd-vault-plugin.git",
      tag:      "v1.13.0",
      revision: "6866b7206719e9b5b2ea4d7cb870e18f76534637"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba895ae1758b44f1945e9f5b0f2021e667490c19abc327a593ae413f0e174388"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba895ae1758b44f1945e9f5b0f2021e667490c19abc327a593ae413f0e174388"
    sha256 cellar: :any_skip_relocation, monterey:       "f55e7b1fb2509476b10cd88e06bc638f7e69022bb11eee1612fa69ff300f9232"
    sha256 cellar: :any_skip_relocation, big_sur:        "f55e7b1fb2509476b10cd88e06bc638f7e69022bb11eee1612fa69ff300f9232"
    sha256 cellar: :any_skip_relocation, catalina:       "f55e7b1fb2509476b10cd88e06bc638f7e69022bb11eee1612fa69ff300f9232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf55919acbd659b5a2627cd0014491e5627de33dfcdda196c5dd268ae2e0b6e0"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/argoproj-labs/argocd-vault-plugin/version.Version=#{version}
      -X github.com/argoproj-labs/argocd-vault-plugin/version.BuildDate=#{time.iso8601}
      -X github.com/argoproj-labs/argocd-vault-plugin/version.CommitSHA=#{Utils.git_head}
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
