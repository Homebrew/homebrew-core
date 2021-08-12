class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://github.com/IBM/argocd-vault-plugin"
  url "https://github.com/IBM/argocd-vault-plugin.git",
      tag:      "v1.1.4",
      revision: "57287c3b09b9b46fc0a2cc2b6344cdef5e01d2c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ff2832b21bdfcab32ccf9ade4848963917463fbb78acd1bed2d44d748c5a826c"
    sha256 cellar: :any_skip_relocation, big_sur:       "a3b51c12f1df9561c372db2f99cd4f1500254522eace8b3a2df2ba448e939b6b"
    sha256 cellar: :any_skip_relocation, catalina:      "a3b51c12f1df9561c372db2f99cd4f1500254522eace8b3a2df2ba448e939b6b"
    sha256 cellar: :any_skip_relocation, mojave:        "a3b51c12f1df9561c372db2f99cd4f1500254522eace8b3a2df2ba448e939b6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2863913ebae47cc22e5e703c442f795a3e11aca936e2d1d5946c129879f4161b"
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
