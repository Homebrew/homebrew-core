class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.9.0",
      revision: "a1534cc2f581bbc93c15fa5ac42fe5c59f03d66a"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08d870e43ac0ee793eb1f375dafa0ad4f0558898dcf78a9728e85caf77af183a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5deccd4a24df2e5081c7f973df49afb89ab09a2ec89da4f13b82e85b75bc9d4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9abfe4121f7f6ac20d99ae379b024d63227e8e07fa2c550eeb2e809011ac70ec"
    sha256 cellar: :any_skip_relocation, ventura:        "ca30e424242ecd88fdbf8ac80f55501a6f5071f3878267d0f4b434c5e0a41443"
    sha256 cellar: :any_skip_relocation, monterey:       "9c7c7461e7a14795ac08e88fe27b8f8268897366f05fabdb163b9040c4e50f3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1392441bd2ac5465819dd92900b9b2bacb8a3a0f89cd351a0f31c7376f89ce4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63dc43a95133f2e7ad0e8dc7c017d975a65af77be18d8a134ba7dbd2bf7607a0"
  end

  depends_on "go" => :build

  def install
    project = "github.com/kyverno/kyverno"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.BuildVersion=#{version}
      -X #{project}/pkg/version.BuildHash=#{Utils.git_head}
      -X #{project}/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli/kubectl-kyverno"

    generate_completions_from_executable(bin/"kyverno", "completion")
  end

  test do
    assert_match "Test Summary: 0 tests passed and 0 tests failed", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, "#{bin}/kyverno version"
  end
end
