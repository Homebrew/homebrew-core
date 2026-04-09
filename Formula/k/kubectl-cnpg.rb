class KubectlCnpg < Formula
  desc "CloudNativePG plugin for kubectl"
  homepage "https://cloudnative-pg.io/"
  url "https://github.com/cloudnative-pg/cloudnative-pg.git",
      tag:      "v1.29.0",
      revision: "23eae00cd7aad82978397798dd27b600eb25ae3d"
  license "Apache-2.0"
  head "https://github.com/cloudnative-pg/cloudnative-pg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d0ad36ff850b3d1af2dd9fced6fc79900725eb4befea43623ba92261b09912e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6b5873dc9b19e0fcd97bd2adf8b04c5a971234ecd97ab8f518f5ccb0e590cd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5311eb25705d192462a83c12c17d894732343141ee31cbd1ed1b12d19ea33037"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fd9ddd9b1f1b4b23b0ee9f971ef8f14e1a50028c0d29ad613af8060b22e1562"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db6eae479d43d7884030039f5373fdb46a51afdd23082ac7da2eabcf9948554d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66eda2b640c7c4dd0765b46b3fa46e0b8ebf23b25b0c57751bdef5c42addeb2d"
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
