class KubectlCnpg < Formula
  desc "CloudNativePG plugin for kubectl"
  homepage "https://cloudnative-pg.io/"
  url "https://github.com/cloudnative-pg/cloudnative-pg.git",
      tag:      "v1.28.1",
      revision: "1ecc48340a5fcc7243773bb8d84e59e24d6909a3"
  license "Apache-2.0"
  head "https://github.com/cloudnative-pg/cloudnative-pg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81981c8eccd3173eb11b7e94f2a61012539805560335279d00396c8cf5a653d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f991229063c39309140450ff268cf42b38a2b54b1c240c2226d623e8d756e0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bc47ada833c8d1fa6f633ee2d92debb643616ce2b1b3c28fb872175d27b37ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3963933a18f771958f99fb6fc0ad9ba9edb8a8042fbbb5250000625c55f729d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ebd19955d65aa8d6ee9b7c840a4c8b2ff9ff9b494bf71a1c4d63f07dbc651bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "836d53fa78ba01f7942b6c9d23b2ffbe3b9907f65d6420831e404292f29e3979"
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
