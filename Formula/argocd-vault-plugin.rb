class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://argocd-vault-plugin.readthedocs.io"
  url "https://github.com/IBM/argocd-vault-plugin.git",
      tag:      "v1.7.0",
      revision: "cfd17486e894c9df5a8aa342967e164e800e16f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fca747871620bbde74fbe76f32b631ac60dcd9c55d8ca9c92d7556381bc8080"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fca747871620bbde74fbe76f32b631ac60dcd9c55d8ca9c92d7556381bc8080"
    sha256 cellar: :any_skip_relocation, monterey:       "f1584c2d9557be4446e6469d2adf5d1f10bad618b8984369416210233eca2397"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1584c2d9557be4446e6469d2adf5d1f10bad618b8984369416210233eca2397"
    sha256 cellar: :any_skip_relocation, catalina:       "f1584c2d9557be4446e6469d2adf5d1f10bad618b8984369416210233eca2397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60985ce9f2a62e449e0c2d111542d5cff3043ab355c04dd599ffc3638bfff528"
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
