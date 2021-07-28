class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://github.com/IBM/argocd-vault-plugin"
  url "https://github.com/IBM/argocd-vault-plugin.git",
      tag:      "v1.1.4",
      revision: "57287c3b09b9b46fc0a2cc2b6344cdef5e01d2c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "518d929fab4a8802813aa4982acf523107a54a38d0fd9bb30afe5e145be6b4c5"
    sha256 cellar: :any_skip_relocation, big_sur:       "b599fcd9410c691d8762f4d7c5caeaf767f7538f259edf2364acd477aaebcc48"
    sha256 cellar: :any_skip_relocation, catalina:      "b599fcd9410c691d8762f4d7c5caeaf767f7538f259edf2364acd477aaebcc48"
    sha256 cellar: :any_skip_relocation, mojave:        "b599fcd9410c691d8762f4d7c5caeaf767f7538f259edf2364acd477aaebcc48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3948e0f8ea479a564bea2021b40f84089494f0618fa5a5feb5dc32dc79caf934"
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
    assert_match "This is a plugin to replace <wildcards> with Vault secrets",
      shell_output("#{bin}/argocd-vault-plugin --help")

    touch testpath/"empty.yaml"
    assert_match "Error: Must provide a supported Vault Type",
      shell_output("#{bin}/argocd-vault-plugin generate ./empty.yaml 2>&1", 1)
  end
end
