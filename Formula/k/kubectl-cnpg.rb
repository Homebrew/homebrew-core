class KubectlCnpg < Formula
  desc "CloudNativePG plugin for kubectl"
  homepage "https://cloudnative-pg.io/"
  url "https://github.com/cloudnative-pg/cloudnative-pg.git",
      tag:      "v1.27.0",
      revision: "8b442dcc3d2390e891ec4a53fe576fe9936dfa08"
  license "Apache-2.0"
  head "https://github.com/cloudnative-pg/cloudnative-pg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1aa8f2df75d43b1281ee084940d66cd87971f089fc60420a624276c9f6022d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ac3f20b1d4719e1a4e71aa47b7714368cd349ec33423bad2802c1c52eb86c03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1dadb4e7adef1cd01d7fa65ff95fc3a4d6f91510629d8c87984f23ba616f5b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0e214980d5c051ac01973f044884b1424bac6ec033003ecdde7060c955731fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "7776ab85ddf401e47f9f321133a60fb7ab62cc049fa9452c1264449213802ba3"
    sha256 cellar: :any_skip_relocation, ventura:       "dc6d18acb68efc9336eb21864f0351827cc420e8a601e2f92cb1554f885e2956"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f1e1735e902b83030e9e6b176de8a245b458b7b183746201b4cf2c4125d305c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42ff3a6416cd3de178163da56cdc7607dad390dd97ad7e973e23273f43a1f93e"
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
