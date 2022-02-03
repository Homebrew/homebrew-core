class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://argocd-vault-plugin.readthedocs.io"
  url "https://github.com/IBM/argocd-vault-plugin.git",
      tag:      "v1.8.0",
      revision: "aa8abb0efba2759fc2b86aadb5f0904eb972348e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18d98d381d68e95f0946a3c80cc0d5377953b1fcc42dcb079f60e3f8de96e395"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18d98d381d68e95f0946a3c80cc0d5377953b1fcc42dcb079f60e3f8de96e395"
    sha256 cellar: :any_skip_relocation, monterey:       "04cff6a4fbcc65b6f72f2bd0791a93d986bfe5a497ee8c6ebe2ef83989830ea2"
    sha256 cellar: :any_skip_relocation, big_sur:        "04cff6a4fbcc65b6f72f2bd0791a93d986bfe5a497ee8c6ebe2ef83989830ea2"
    sha256 cellar: :any_skip_relocation, catalina:       "04cff6a4fbcc65b6f72f2bd0791a93d986bfe5a497ee8c6ebe2ef83989830ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c7b3a4160b39c4d35f20c8eaf465d445de7e6b194c813899db67af4d3126a10"
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
