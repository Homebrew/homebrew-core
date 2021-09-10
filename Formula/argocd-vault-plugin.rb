class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://ibm.github.io/argocd-vault-plugin"
  url "https://github.com/IBM/argocd-vault-plugin.git",
      tag:      "v1.3.1",
      revision: "f7c18ea3ee264bf3850195c496889943675d2b59"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ecbdf8e9f06163349e258430fb6c495e06c65905cfe0f32fcafd4d57f755a0f7"
    sha256 cellar: :any_skip_relocation, big_sur:       "c10851045ea0d15ad39017be2ae7f5fccf71a779f215ba752cc2864675bf7bfc"
    sha256 cellar: :any_skip_relocation, catalina:      "c10851045ea0d15ad39017be2ae7f5fccf71a779f215ba752cc2864675bf7bfc"
    sha256 cellar: :any_skip_relocation, mojave:        "c10851045ea0d15ad39017be2ae7f5fccf71a779f215ba752cc2864675bf7bfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ffde97112087a75f9dda2d6d13e699a6efd72dbf57612ee38a7b1d9ca15d08f"
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
