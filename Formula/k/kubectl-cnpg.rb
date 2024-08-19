class KubectlCnpg < Formula
  desc "CloudNativePG plugin for kubectl"
  homepage "https://cloudnative-pg.io/"
  url "https://github.com/cloudnative-pg/cloudnative-pg.git",
      tag:      "v1.23.3",
      revision: "2b489ad6a0b5013af1534adc282592a15aaf9869"
  license "Apache-2.0"
  head "https://github.com/cloudnative-pg/cloudnative-pg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb9d30ef5a60b16ff6bc83bf6be54599b9fd2069de38ebc824323685c5a95c43"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db3096a74819008179381b643f53ed47c692ed40bd8a1b85315d30aa1b4c91ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "740073de332592ab9a476c374fd90338198e9e21a6c1b7a3f9faf769fe7bd9dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "30e5c93cb2ca444c33deba382383545f7da44d36321ec6862ba02718b8c8acfc"
    sha256 cellar: :any_skip_relocation, ventura:        "d8e2e590b71378b06c1c61ee8ac3dfdfa43523b818930c36b625f0666ff964e9"
    sha256 cellar: :any_skip_relocation, monterey:       "745333e61c8a896c818cf0483a02e502beb55bcf8463ed9cd43fa69dfd289d9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07a4b130da83cc9e400617c27073cd152decb55406e0ceeaa01891946d06457e"
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
