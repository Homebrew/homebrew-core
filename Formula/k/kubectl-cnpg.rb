class KubectlCnpg < Formula
  desc "CloudNativePG plugin for kubectl"
  homepage "https://cloudnative-pg.io/"
  url "https://github.com/cloudnative-pg/cloudnative-pg.git",
      tag:      "v1.23.2",
      revision: "4bef841286ef84c4b435a6204a7ee632e1d4fb57"
  license "Apache-2.0"
  head "https://github.com/cloudnative-pg/cloudnative-pg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c23cb712a0255d302896c4deadbd2786f31707e7607e53394f3430ee38841ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0dd3a730a93a6f78c90963ea6719d4597744dd7c723500b594d460a714802510"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90e80871edab957c755ddb79f50a696e793dc655ed63955761f826b6ad0efd88"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a1cb0961c1c2161ace3cb52ca55f8cf40705a38ed794bb1867f0afec4a8964e"
    sha256 cellar: :any_skip_relocation, ventura:        "d9a8afc77daa568337cbb1e4a7cfcde04a0e536be86e4e59218ad37cc168cb1a"
    sha256 cellar: :any_skip_relocation, monterey:       "19c158aaaad842a055a56cad753732331818ae3b20ca479041bb3aea6dc5a229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a8a61ce931522783d219315f4cd70da0541b6729e6abeeadd3d8dbb9eb00d60"
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
