class KubectlCnpg < Formula
  desc "CloudNativePG plugin for kubectl"
  homepage "https://cloudnative-pg.io/"
  url "https://github.com/cloudnative-pg/cloudnative-pg.git",
      tag:      "v1.24.1",
      revision: "3f96930d984ff7e795e013160afbc6d3012f8718"
  license "Apache-2.0"
  head "https://github.com/cloudnative-pg/cloudnative-pg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b19bf771b8590bbb1c60ff016e67ee9e8b6d9b5c41942ba9407388299d577f1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2221c3d8752bca7a298711bf8c7c118243aa505e92a92917824735e186dd0fac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0895fc09d7888bb271c315d2b1f3a4cdf5448bcf072932be4134464ae1224e51"
    sha256 cellar: :any_skip_relocation, sonoma:        "09688dc982a5094a056a0ea3e5e98ac86a8e159d91061c84d5d89e41bed0398e"
    sha256 cellar: :any_skip_relocation, ventura:       "3ac45046f88ba7f0cebc648922cc81897658938f0210ef5852e359e337bfa16d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9d453dee5d90f7bbeebd1263f3310f155d14e61036700cd38f441c9b8d37312"
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
    generate_completions_from_executable(bin/"kubectl-cnpg", "completion")

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
