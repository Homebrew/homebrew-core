class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://ibm.github.io/argocd-vault-plugin"
  url "https://github.com/IBM/argocd-vault-plugin.git",
      tag:      "v1.4.0",
      revision: "60fed6f08b363f92d61760f48ac80da704f5c1c5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7f935402de3f17764fdb9aa9e7c21af41934d8506331fa553a8b3670dde9796f"
    sha256 cellar: :any_skip_relocation, big_sur:       "d2e4d0929510b6c8e789a68e7776044ee0983a1e0340c6639141f2aa81ac5e32"
    sha256 cellar: :any_skip_relocation, catalina:      "d2e4d0929510b6c8e789a68e7776044ee0983a1e0340c6639141f2aa81ac5e32"
    sha256 cellar: :any_skip_relocation, mojave:        "d2e4d0929510b6c8e789a68e7776044ee0983a1e0340c6639141f2aa81ac5e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1c1ee60e7722163d06abe33c84e070ed9a3ac509a9fdd9be05aa3c059bf0fc9"
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
