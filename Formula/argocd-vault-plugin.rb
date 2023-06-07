class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://argocd-vault-plugin.readthedocs.io"
  url "https://github.com/argoproj-labs/argocd-vault-plugin.git",
      tag:      "v1.14.0",
      revision: "98e3987befca45c9c2bdc2e915c37de7e5688b37"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57b00a3bcf3f7c592fa109409c50661949d57b94172c63165581329fc62a13db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57b00a3bcf3f7c592fa109409c50661949d57b94172c63165581329fc62a13db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57b00a3bcf3f7c592fa109409c50661949d57b94172c63165581329fc62a13db"
    sha256 cellar: :any_skip_relocation, ventura:        "4be2d9817298ef1c57772ac31648a57cfa53762cb3417c550af6c74d64e45b58"
    sha256 cellar: :any_skip_relocation, monterey:       "4be2d9817298ef1c57772ac31648a57cfa53762cb3417c550af6c74d64e45b58"
    sha256 cellar: :any_skip_relocation, big_sur:        "4be2d9817298ef1c57772ac31648a57cfa53762cb3417c550af6c74d64e45b58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f69f1980a20ee9ec591e7d7fe2888794d8c80dde5ea964425500bdfb568dce9"
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

    generate_completions_from_executable(bin/"argocd-vault-plugin", "completion")
  end

  test do
    assert_match "This is a plugin to replace <placeholders> with Vault secrets",
      shell_output("#{bin}/argocd-vault-plugin --help")

    touch testpath/"empty.yaml"
    assert_match "Error: Must provide a supported Vault Type",
      shell_output("#{bin}/argocd-vault-plugin generate ./empty.yaml 2>&1", 1)
  end
end
