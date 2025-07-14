class KubectlCnpg < Formula
  desc "CloudNativePG plugin for kubectl"
  homepage "https://cloudnative-pg.io/"
  url "https://github.com/cloudnative-pg/cloudnative-pg.git",
      tag:      "v1.26.0",
      revision: "1535f3c1742525b93f4f8bbb7dd37e42e122f41f"
  license "Apache-2.0"
  head "https://github.com/cloudnative-pg/cloudnative-pg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a339ca5822e7b417cd46461374919dbd798a48d701d46bc2d40d89e3a7772daa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f4eb3a399264a14a98e2f3fbd5a4de4f406f2a8010cafe1111274b46e833248"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad83fd5102fb19a49442605a0e4419340deb1e00c71c57999a33ae7da6bb3e33"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ac1e1631619a24b8a9cd81349b4e74dceeeabb2f1aafac51a2452da572f378c"
    sha256 cellar: :any_skip_relocation, ventura:       "2b00fc7ce3a60102e5f142cd003a224569e95b8569b9171d86bfffe588a50dd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8615eff268483c463a72f8797a31fb897fb544a85885387c57c7aabbedc14acf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2847546797fed57f2d1dccd1ff5c5af84fd021328f0a9df03ade21ecc411b73"
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
