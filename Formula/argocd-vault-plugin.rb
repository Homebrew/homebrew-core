class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://ibm.github.io/argocd-vault-plugin"
  url "https://github.com/IBM/argocd-vault-plugin.git",
      tag:      "v1.2.0",
      revision: "44a1e9a75d64dd3d5410acfd525128ece1ab1726"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9018b5a9e630fd660f49193e51d2dd43b4a2a0d751cdcca4ca85a42cca22d16b"
    sha256 cellar: :any_skip_relocation, big_sur:       "7ff5b5b148a9399665f8a58c0b9567ae4449d3754fee9eadabadd42c927aff2e"
    sha256 cellar: :any_skip_relocation, catalina:      "7ff5b5b148a9399665f8a58c0b9567ae4449d3754fee9eadabadd42c927aff2e"
    sha256 cellar: :any_skip_relocation, mojave:        "7ff5b5b148a9399665f8a58c0b9567ae4449d3754fee9eadabadd42c927aff2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "255735a047513406afe27b380422dc8f3fca65f082a77314a18f212fab6dd2e3"
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
