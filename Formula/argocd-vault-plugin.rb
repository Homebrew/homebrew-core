class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://argocd-vault-plugin.readthedocs.io"
  url "https://github.com/IBM/argocd-vault-plugin.git",
      tag:      "v1.10.1",
      revision: "142fc413f4fdf5e69db4f99675df3d9d00317553"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da7fcd4e0911ad4490efa8b2a0abab50b03c96d7e139bab8f4e9152d4965df3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da7fcd4e0911ad4490efa8b2a0abab50b03c96d7e139bab8f4e9152d4965df3e"
    sha256 cellar: :any_skip_relocation, monterey:       "6db208de458e5a0572f206b3459bfafd9da80b33657e55b8e686b61f632f9789"
    sha256 cellar: :any_skip_relocation, big_sur:        "6db208de458e5a0572f206b3459bfafd9da80b33657e55b8e686b61f632f9789"
    sha256 cellar: :any_skip_relocation, catalina:       "6db208de458e5a0572f206b3459bfafd9da80b33657e55b8e686b61f632f9789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99c606b81aeca364f0d3df6582b9c4286ceff8f6c77e379f33ad541e8c683252"
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
