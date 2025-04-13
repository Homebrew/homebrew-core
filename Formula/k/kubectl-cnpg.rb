class KubectlCnpg < Formula
  desc "CloudNativePG plugin for kubectl"
  homepage "https://cloudnative-pg.io/"
  url "https://github.com/cloudnative-pg/cloudnative-pg.git",
      tag:      "v1.25.1",
      revision: "c56e00d462c3899ab305540953ec541dfe0f762a"
  license "Apache-2.0"
  head "https://github.com/cloudnative-pg/cloudnative-pg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eef1ff7ca53af3891f898f520735df2e69fe4fcb24841d3a447f99d0f5a2061b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4226559582506b3252d8d45e811c29435227c1b5cf78a6d163d2d65bb32d7729"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "655ed874d5339f320386c7f72f4fa695c73a999384ed26972edeb2dba05b8f0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "366ab715e16ca498fdf42c74dff96d6b27866c58e4382e3d8fcf6c7d1bf5ac92"
    sha256 cellar: :any_skip_relocation, ventura:       "39ede94e7eb67365e4405dc6e02f937c955b21615e010316dee16b67141b3357"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad28fc9e4d7c06afae38b2ce371c56d41516456abb2931f1509dc75608c804ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "844c03ae717e2cdbfc127e39e8d97d8560dedc708f8ba8af8471262a950152cb"
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
