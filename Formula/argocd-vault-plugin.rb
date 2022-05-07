class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://argocd-vault-plugin.readthedocs.io"
  url "https://github.com/argoproj-labs/argocd-vault-plugin.git",
      tag:      "v1.11.0",
      revision: "4133295001e037b917a8884da84af42f12a51cae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2058ed2abe0a5c050f2944a22aa9049f68a3d3778c43d77329ea24e30e69985"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2058ed2abe0a5c050f2944a22aa9049f68a3d3778c43d77329ea24e30e69985"
    sha256 cellar: :any_skip_relocation, monterey:       "8913663ce63800efd24b419b70375ac8b2fd202162b2c5ba75e7c62aeb0192e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "8913663ce63800efd24b419b70375ac8b2fd202162b2c5ba75e7c62aeb0192e1"
    sha256 cellar: :any_skip_relocation, catalina:       "8913663ce63800efd24b419b70375ac8b2fd202162b2c5ba75e7c62aeb0192e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1792a0e85386afe7070634fff7c70fefe1de375bab92fdca033641089581b82"
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
