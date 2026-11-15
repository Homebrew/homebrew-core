class KubectlCnpg < Formula
  desc "CloudNativePG plugin for kubectl"
  homepage "https://cloudnative-pg.io/"
  url "https://github.com/cloudnative-pg/cloudnative-pg.git",
      tag:      "v1.30.1",
      revision: "2a35abb4628f209d149825ef3c38011e0701ff2f"
  license "Apache-2.0"
  head "https://github.com/cloudnative-pg/cloudnative-pg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7e5eca805b095ddaf8f3514bb208d42a0d3a39f3fbb65e051b7d276c0448c4d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8f414e333fd0bd1c6c89d02dcdd6e7a67613b773d3517bb18dec38f5a2e0501d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "24d6554b125b03e8b792d5fea6224c11e5b390ed62a566f327e20ee60e5a9b20"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2a542c9fbefc1c15566f31fe8dbb5947410927dc94e1fd704bb24cf8ed76fed2"
    sha256 cellar: :any,                 x86_64_linux:      "f57c6a3b61299a15791316cffa19465958b3b0bbea802ae95dfb2215affc3195"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/cloudnative-pg/cloudnative-pg/pkg/versions.buildVersion=#{version}
      -X github.com/cloudnative-pg/cloudnative-pg/pkg/versions.buildCommit=#{Utils.git_head}
      -X github.com/cloudnative-pg/cloudnative-pg/pkg/versions.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubectl-cnpg"
    generate_completions_from_executable(bin/"kubectl-cnpg", shell_parameter_format: :cobra)

    kubectl_plugin_completion = <<~SH
      #!/usr/bin/env sh
      # Call the __complete command passing it all arguments
      kubectl cnpg __complete "$@"
    SH

    (bin/"kubectl_complete-cnpg").write(kubectl_plugin_completion)
    chmod 0755, bin/"kubectl_complete-cnpg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubectl-cnpg version")
    assert_match "connect: connection refused", shell_output("#{bin}/kubectl-cnpg status dummy-cluster 2>&1", 1)
  end
end
