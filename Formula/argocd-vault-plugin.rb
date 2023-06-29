class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://argocd-vault-plugin.readthedocs.io"
  url "https://github.com/argoproj-labs/argocd-vault-plugin.git",
      tag:      "v1.15.0",
      revision: "2513543f4a76a28567a14aef608d60678d140aba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6db993b409020cd221c279cb591eafe7654cd9ea89ba9e0864a2b7ccd3dd887"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6db993b409020cd221c279cb591eafe7654cd9ea89ba9e0864a2b7ccd3dd887"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6db993b409020cd221c279cb591eafe7654cd9ea89ba9e0864a2b7ccd3dd887"
    sha256 cellar: :any_skip_relocation, ventura:        "618ac122543fddba289ad77e41fb8359558600be56ab575605a6d1a8adee1094"
    sha256 cellar: :any_skip_relocation, monterey:       "618ac122543fddba289ad77e41fb8359558600be56ab575605a6d1a8adee1094"
    sha256 cellar: :any_skip_relocation, big_sur:        "618ac122543fddba289ad77e41fb8359558600be56ab575605a6d1a8adee1094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "117066f0258c010fe1020de5e90896ce54019345f292447c65616c8b8667a7a9"
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
