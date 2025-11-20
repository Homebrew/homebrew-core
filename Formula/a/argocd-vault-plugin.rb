class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://argocd-vault-plugin.readthedocs.io"
  url "https://github.com/argoproj-labs/argocd-vault-plugin.git",
      tag:      "v1.18.1",
      revision: "fc452cdd8d4727b412ce3de61ee0416efd75050d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "6955e65b88cd94b91c5780fa18da4ee2804568242e0560e3c5143e92484269c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "16c6f66c3a9728fb32b1098e4ac611c9e7f85d3da8fd59c464ec6662d8f472a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7dcbaa4f8fea11cbc2bff01602fe23caece755107e78213214a490423315938"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7dcbaa4f8fea11cbc2bff01602fe23caece755107e78213214a490423315938"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7dcbaa4f8fea11cbc2bff01602fe23caece755107e78213214a490423315938"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5b3dae256fd58870d8257ad93bb990e01c59847de737cf6e11328568c07a518"
    sha256 cellar: :any_skip_relocation, ventura:        "e5b3dae256fd58870d8257ad93bb990e01c59847de737cf6e11328568c07a518"
    sha256 cellar: :any_skip_relocation, monterey:       "e5b3dae256fd58870d8257ad93bb990e01c59847de737cf6e11328568c07a518"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "71c58033fef7e4eac8c71e825df10dc0b275ce7fea93cd798e46780e89005a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dea50d0a56408e8c396cb0bfc6534f025bc2e8acefb125f59a32a0fecc9eee89"
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

    system "go", "build", *std_go_args(ldflags:)

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
