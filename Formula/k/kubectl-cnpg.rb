class KubectlCnpg < Formula
  desc "CloudNativePG plugin for kubectl"
  homepage "https://cloudnative-pg.io/"
  url "https://github.com/cloudnative-pg/cloudnative-pg.git",
      tag:      "v1.28.0",
      revision: "a9696201f760013182c6cdba7c4ed3c236a6423b"
  license "Apache-2.0"
  head "https://github.com/cloudnative-pg/cloudnative-pg.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4acd9b902c8d1a8de896b1b9f8d3496562cbc777c9cc3af62c04c6244490cc51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e5c5e274901fbc7fd4e0da0d4babee96778604b636fb9219e8a57936b310f41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "689e64a206157534045538dee2778cfcf750c4ad1ce007d40c2ef66c0baa7dd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad54820b63e1c500d1f0d923bdd2ea58940e75b5fcbc594fe30ce977a0a11fbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3141c9f96f0c1d110a52051135775217c6cde6752aab7717f691be25d1b7f572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fc75f49da81511a3d323abd96d33d174ef14dcb82cbcde0a0ddce775242dd80"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/cloudnative-pg/cloudnative-pg/pkg/versions.buildVersion=#{version}
      -X github.com/cloudnative-pg/cloudnative-pg/pkg/versions.buildCommit=#{Utils.git_head}
      -X github.com/cloudnative-pg/cloudnative-pg/pkg/versions.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubectl-cnpg"
    generate_completions_from_executable(bin/"kubectl-cnpg", shell_parameter_format: :cobra)

    kubectl_plugin_completion = <<~EOS
      #!/usr/bin/env sh
      # Call the __complete command passing it all arguments
      kubectl cnpg __complete "$@"
    EOS

    (bin/"kubectl_complete-cnpg").write(kubectl_plugin_completion)
    chmod 0755, bin/"kubectl_complete-cnpg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubectl-cnpg version")
    assert_match "connect: connection refused", shell_output("#{bin}/kubectl-cnpg status dummy-cluster 2>&1", 1)
  end
end
