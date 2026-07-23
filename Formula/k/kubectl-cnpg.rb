class KubectlCnpg < Formula
  desc "CloudNativePG plugin for kubectl"
  homepage "https://cloudnative-pg.io/"
  url "https://github.com/cloudnative-pg/cloudnative-pg.git",
      tag:      "v1.30.0",
      revision: "4b5e244a7d031f67e025c83c1555e7726ecbbfa1"
  license "Apache-2.0"
  head "https://github.com/cloudnative-pg/cloudnative-pg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3d851e9c702d01d26d9eafc8f27228face0d85222cf9857d62fdf847dbae2ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "704de512ab1ccc428982363bf159f08357bece9c42e42eb2d2b2c8094a695fb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da76c0b031442f3a338473f030b48a241963a7adf83eca26d5c864b2df80329a"
    sha256 cellar: :any_skip_relocation, sonoma:        "82ba554323b5252b43fd32f79a86ce1a9259916fd2ddcd0962f2a1e2e32fc170"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa158a9bd1b3baf0a17be94bc2bc5b19e6083b2c2d4c6b6e427298e40fa39d94"
    sha256 cellar: :any,                 x86_64_linux:  "6b425af985eeb98c57917e78d4db13a8cd893f6138d42104a14cf209fd1b938e"
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
