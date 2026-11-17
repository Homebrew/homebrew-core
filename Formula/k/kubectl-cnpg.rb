class KubectlCnpg < Formula
  desc "CloudNativePG plugin for kubectl"
  homepage "https://cloudnative-pg.io/"
  url "https://github.com/cloudnative-pg/cloudnative-pg.git",
      tag:      "v1.30.2",
      revision: "30cca36d32328a78dc96c51db966ce629d5b72db"
  license "Apache-2.0"
  head "https://github.com/cloudnative-pg/cloudnative-pg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2ecd67f03618990bfe0ee0b67d32978e58f7e6eeff5cb4ab0ab7145a967f76ff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "075bdcda76acb47ef9e5c837418a7fd43468fc1f3127599e830f26432dcd69dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1b5784eb4ac25b434874830b1799a7f8b6c98fa6f6b968bfdb7576ec08341410"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9d39866d4be8e7cca82c835c11e0a330b988a7fe37d0d1a0dc1a63ee81e33476"
    sha256 cellar: :any,                 x86_64_linux:      "e70eaf2e7defea765bc0bb87a3cb749af450474ca1cff4cf826c74cf6ab390de"
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
