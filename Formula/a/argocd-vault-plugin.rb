class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://argocd-vault-plugin.readthedocs.io"
  url "https://github.com/argoproj-labs/argocd-vault-plugin.git",
      tag:      "v1.17.0",
      revision: "b393c7afa63a43197c084a99959a78d0d26e5e74"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "751d8825ad59355be8be07aa151a0636b51b3f36244c9dc4b43196924f481354"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "751d8825ad59355be8be07aa151a0636b51b3f36244c9dc4b43196924f481354"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "751d8825ad59355be8be07aa151a0636b51b3f36244c9dc4b43196924f481354"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8a39a9ec1e919f7931e586ab7d17c09a5ef7dc252de0aa60d4e1aa87a368149"
    sha256 cellar: :any_skip_relocation, ventura:        "e8a39a9ec1e919f7931e586ab7d17c09a5ef7dc252de0aa60d4e1aa87a368149"
    sha256 cellar: :any_skip_relocation, monterey:       "e8a39a9ec1e919f7931e586ab7d17c09a5ef7dc252de0aa60d4e1aa87a368149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75ec9163c119d670352008b558f1c6d96d651dcc804bad145f068021751ee70d"
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
