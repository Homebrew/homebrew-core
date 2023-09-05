class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://argocd-vault-plugin.readthedocs.io"
  url "https://github.com/argoproj-labs/argocd-vault-plugin.git",
      tag:      "v1.16.1",
      revision: "77b07b1d16442a0faef952d4f910f3fac008845d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7be79ced0f90cd76b237f13cf3f42fa7122d361b7cf3c512dac7952b5e13a84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7be79ced0f90cd76b237f13cf3f42fa7122d361b7cf3c512dac7952b5e13a84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7be79ced0f90cd76b237f13cf3f42fa7122d361b7cf3c512dac7952b5e13a84"
    sha256 cellar: :any_skip_relocation, ventura:        "084167429a16d4611084a75ec7641c67e793c56b5370c3002940a61681210d64"
    sha256 cellar: :any_skip_relocation, monterey:       "084167429a16d4611084a75ec7641c67e793c56b5370c3002940a61681210d64"
    sha256 cellar: :any_skip_relocation, big_sur:        "084167429a16d4611084a75ec7641c67e793c56b5370c3002940a61681210d64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba21a70daa6c9a99c6055fd483a7ba1207f032e661e9fece4095d91c9ab6a385"
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
