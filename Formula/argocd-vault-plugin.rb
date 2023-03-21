class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://argocd-vault-plugin.readthedocs.io"
  url "https://github.com/argoproj-labs/argocd-vault-plugin.git",
      tag:      "v1.14.0",
      revision: "98e3987befca45c9c2bdc2e915c37de7e5688b37"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d5bbe6e17f74c44075b01a0dc7719b3fb73e718b5389699fd995fe678d30769"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d5bbe6e17f74c44075b01a0dc7719b3fb73e718b5389699fd995fe678d30769"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d5bbe6e17f74c44075b01a0dc7719b3fb73e718b5389699fd995fe678d30769"
    sha256 cellar: :any_skip_relocation, ventura:        "b71cb1ba8d4561176ed6fdd7f15a1567eef841c60059415bbefb321c62a28d52"
    sha256 cellar: :any_skip_relocation, monterey:       "b71cb1ba8d4561176ed6fdd7f15a1567eef841c60059415bbefb321c62a28d52"
    sha256 cellar: :any_skip_relocation, big_sur:        "b71cb1ba8d4561176ed6fdd7f15a1567eef841c60059415bbefb321c62a28d52"
    sha256 cellar: :any_skip_relocation, catalina:       "b71cb1ba8d4561176ed6fdd7f15a1567eef841c60059415bbefb321c62a28d52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5b6c5b6d0abbe6f6aabe29579bfd1af7f56f7ace4a1f1b79c20b9c79467b183"
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
