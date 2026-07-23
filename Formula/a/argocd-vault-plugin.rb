class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://argocd-vault-plugin.readthedocs.io"
  url "https://github.com/argoproj-labs/argocd-vault-plugin.git",
      tag:      "v1.18.1",
      revision: "fc452cdd8d4727b412ce3de61ee0416efd75050d"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5d4dd6c1a4f16a3c0fd46c1721e996d152df50986c46a1fa43698f6e31ac095"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5d4dd6c1a4f16a3c0fd46c1721e996d152df50986c46a1fa43698f6e31ac095"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5d4dd6c1a4f16a3c0fd46c1721e996d152df50986c46a1fa43698f6e31ac095"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fc47e2adeb0af27bb1ad84156319b7196a8fabd70ea2712e4c673d55e85f867"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69abd86b96dfd35560cff8ca258da75d78e26fbeb2f2a7139e03cf4749f53c2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cd74305d5e1cac49e5621a88abbfcdd897c07e81ebe27ddc30eeeba1cf40260"
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

    generate_completions_from_executable(bin/"argocd-vault-plugin", shell_parameter_format: :cobra)
  end

  test do
    assert_match "This is a plugin to replace <placeholders> with Vault secrets",
      shell_output("#{bin}/argocd-vault-plugin --help")

    touch testpath/"empty.yaml"
    assert_match "Error: Must provide a supported Vault Type",
      shell_output("#{bin}/argocd-vault-plugin generate ./empty.yaml 2>&1", 1)
  end
end
