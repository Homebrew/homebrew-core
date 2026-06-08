class KubectlCnpg < Formula
  desc "CloudNativePG plugin for kubectl"
  homepage "https://cloudnative-pg.io/"
  url "https://github.com/cloudnative-pg/cloudnative-pg.git",
      tag:      "v1.29.1",
      revision: "a4060c152630c9e8958e17d3d23f26b4eb30b69f"
  license "Apache-2.0"
  head "https://github.com/cloudnative-pg/cloudnative-pg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22289e63546e6004364d4dae3015faec6624e56580a1f51a7de621829744744b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "976c1238282bb67672b2bc73ecce1dcc24d9f39714a84d535ce5c87d77434295"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02a073b2a091fe5559ade772b574d8ef3850e609df5589525bc09a0b4b1a8313"
    sha256 cellar: :any_skip_relocation, sonoma:        "8627df6b5b8b56dbbfc1979c88c15c2503cb149a1f7832d1bff5364756fb6c77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13f9639ec5257ded185d53722a51cb8ddbbf907f823c391ae09845421c517564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9961f8175e6107592de0eece1e8c393e67addd6efc559013a48e8173cc64baa"
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
