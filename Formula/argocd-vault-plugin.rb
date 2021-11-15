class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://ibm.github.io/argocd-vault-plugin"
  url "https://github.com/IBM/argocd-vault-plugin.git",
      tag:      "v1.5.0",
      revision: "89e02217591d856e3902be247df36ec7d489270f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29725d605b40f3a0564ec45fd8d9660ae7fb3ea3642878bf697b9114a57ae9bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29725d605b40f3a0564ec45fd8d9660ae7fb3ea3642878bf697b9114a57ae9bf"
    sha256 cellar: :any_skip_relocation, monterey:       "6cf55069bb5c04ae5601b032cbc27af89b56e31ad89c89a83a44c01fc8c6f9b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cf55069bb5c04ae5601b032cbc27af89b56e31ad89c89a83a44c01fc8c6f9b8"
    sha256 cellar: :any_skip_relocation, catalina:       "6cf55069bb5c04ae5601b032cbc27af89b56e31ad89c89a83a44c01fc8c6f9b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c6dc26c96df1176988e63fb90b8df7640b4549a580b7780c616be1ebfd3dc02"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/IBM/argocd-vault-plugin/version.Version=#{version}
      -X github.com/IBM/argocd-vault-plugin/version.BuildDate=#{time.iso8601}
      -X github.com/IBM/argocd-vault-plugin/version.CommitSHA=#{Utils.git_head}
    ].join(" ")

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
