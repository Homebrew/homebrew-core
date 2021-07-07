class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://github.com/IBM/argocd-vault-plugin"
  url "https://github.com/IBM/argocd-vault-plugin.git",
      tag:      "v1.1.2",
      revision: "b91d267dfcc69e8a0f029ca5afed585456f537a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3c1f229027655bc91b7c5cadf3eb3cdb1dff17ec835f98481a3d4c894b250cba"
    sha256 cellar: :any_skip_relocation, big_sur:       "6b227a3932306434c932a256007d4c66a8e95372f23ecc1bed558f03ca0bb1cc"
    sha256 cellar: :any_skip_relocation, catalina:      "c76fcba6af93bfd340c357d2a8aeb852da8f60e86423db24f1be01cfcf5f8621"
    sha256 cellar: :any_skip_relocation, mojave:        "60bd0b9b5584a128339323a7fbe26064c65f4aab718885e83959df00a92be09e"
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
    assert_match "This is a plugin to replace <wildcards> with Vault secrets",
      shell_output("#{bin}/argocd-vault-plugin --help")

    touch testpath/"empty.yaml"
    assert_match "Error: Must provide a supported Vault Type",
      shell_output("#{bin}/argocd-vault-plugin generate ./empty.yaml 2>&1", 1)
  end
end
