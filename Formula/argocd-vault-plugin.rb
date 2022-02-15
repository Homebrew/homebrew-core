class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://argocd-vault-plugin.readthedocs.io"
  url "https://github.com/IBM/argocd-vault-plugin.git",
      tag:      "v1.9.0",
      revision: "305e9905cb8592df08ebe42ffbc44361c0a9bfc6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c53271294247cffd0989f434fd3cb4920e81664ebbf0b8aa4e2731775ba3eacb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c53271294247cffd0989f434fd3cb4920e81664ebbf0b8aa4e2731775ba3eacb"
    sha256 cellar: :any_skip_relocation, monterey:       "3e55c221461bb194cd52e657b1c01efc2e96d10f69f58c765e89b1a01fef29f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e55c221461bb194cd52e657b1c01efc2e96d10f69f58c765e89b1a01fef29f6"
    sha256 cellar: :any_skip_relocation, catalina:       "3e55c221461bb194cd52e657b1c01efc2e96d10f69f58c765e89b1a01fef29f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7390eecdb2846bfab9127c2b1e1c36b7ebaa167dc0272addcfc0aba2cf6cb15"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/IBM/argocd-vault-plugin/version.Version=#{version}
      -X github.com/IBM/argocd-vault-plugin/version.BuildDate=#{time.iso8601}
      -X github.com/IBM/argocd-vault-plugin/version.CommitSHA=#{Utils.git_head}
    ]

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
