class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://argocd-vault-plugin.readthedocs.io"
  url "https://github.com/argoproj-labs/argocd-vault-plugin.git",
      tag:      "v1.13.0",
      revision: "6866b7206719e9b5b2ea4d7cb870e18f76534637"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9478524ce1977ec65883d3e5d86303b14f5ce5005f7e98a31d3707bce8fdb6cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9478524ce1977ec65883d3e5d86303b14f5ce5005f7e98a31d3707bce8fdb6cc"
    sha256 cellar: :any_skip_relocation, monterey:       "940328ea5f655489e46ffbd5bb3a277e9a02fe0b09d2230395405a6460ae9b15"
    sha256 cellar: :any_skip_relocation, big_sur:        "940328ea5f655489e46ffbd5bb3a277e9a02fe0b09d2230395405a6460ae9b15"
    sha256 cellar: :any_skip_relocation, catalina:       "940328ea5f655489e46ffbd5bb3a277e9a02fe0b09d2230395405a6460ae9b15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28226c5bfded825148d0f9fd59242b324fdcbfa447d46edd439911b5e95de0ac"
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
