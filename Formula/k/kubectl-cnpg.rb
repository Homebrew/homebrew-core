class KubectlCnpg < Formula
  desc "CloudNativePG plugin for kubectl"
  homepage "https://cloudnative-pg.io/"
  url "https://github.com/cloudnative-pg/cloudnative-pg.git",
      tag:      "v1.24.0",
      revision: "5fe5bb6b9292c73ebfc1463680b8863abbdb3de3"
  license "Apache-2.0"
  head "https://github.com/cloudnative-pg/cloudnative-pg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a2fa094354e54a0eb5f2afcc24d9f98ac3a7cd3e2662b96997b36f7d7ab99371"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08194de6003590e2995aeb969b9973fa9bdeb0d549f4c44055a20169145eca16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fca31f527336ae2f92871afc5bb31618b61e4c14b9c8e131b015a1bb092e6576"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3976abe30219354b7703b43abdeff8c8b9b132fa7bd741bca8e88797121f1419"
    sha256 cellar: :any_skip_relocation, sonoma:         "93dc44ab70491f01be212aec223dea392b77e392dda855bc96ca0d9c58c2250c"
    sha256 cellar: :any_skip_relocation, ventura:        "9003e906b745968d39b0757e13abc0cfb5d56bf93a77c251d295984a435016fe"
    sha256 cellar: :any_skip_relocation, monterey:       "4f2fef33754a195db5e6d3a2738b8e1ba66f6ab1b873a9a983b7dca5dd03b9e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68c64f352354f9e8f2c32f071ed632c57d9cdb27ad28db79eb825f5afedf90e4"
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
