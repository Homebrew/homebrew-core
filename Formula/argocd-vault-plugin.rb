class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://ibm.github.io/argocd-vault-plugin"
  url "https://github.com/IBM/argocd-vault-plugin.git",
      tag:      "v1.3.1",
      revision: "f7c18ea3ee264bf3850195c496889943675d2b59"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8eb93b97c954c6196323a06967552f7985d37d025f38ccd46b88262640cced52"
    sha256 cellar: :any_skip_relocation, big_sur:       "ed64434e7217f2665d0f83c8dd1ced0cf8166db1be3cf1772903d8b25a9b6bd2"
    sha256 cellar: :any_skip_relocation, catalina:      "ed64434e7217f2665d0f83c8dd1ced0cf8166db1be3cf1772903d8b25a9b6bd2"
    sha256 cellar: :any_skip_relocation, mojave:        "ed64434e7217f2665d0f83c8dd1ced0cf8166db1be3cf1772903d8b25a9b6bd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ea7e8243a670979f3f57d3f46ec7f73d32f2305c67e585de86779f0a9a6c859"
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
