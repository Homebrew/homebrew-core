class KubectlCnpg < Formula
  desc "CloudNativePG plugin for kubectl"
  homepage "https://cloudnative-pg.io/"
  url "https://github.com/cloudnative-pg/cloudnative-pg.git",
      tag:      "v1.27.1",
      revision: "9daa681325034a6b6548e347bbc4c0b54ea668db"
  license "Apache-2.0"
  head "https://github.com/cloudnative-pg/cloudnative-pg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "392a064aa12d5e40f55b35061fe1800594eb5ea66863fbf77590c7ae5528a3f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d29865bb34afa1f9152d4b4ea21c2a78f8eb9dcbd958bad4b1e8ba0a2475c24e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32ea22e183ec27a7c79601151eb4f004038a22677b7367ddcebe5c699e1bc09d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc15b6164284c36b2d6abde9b10c3778d26b8f0551b6567849801ac0874a1c68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02659694a1f48ba3e47d6947812697e39614bcc39c522711b54aaa0f98f69028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10c07f5003833bf23f90bda112bc90900d86c7affc570c7cade011fd875d8a1f"
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
