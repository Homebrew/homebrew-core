class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.8.6.tar.gz"
  sha256 "43c1353301cbc91c250da1efa06dabeefff4f90f2f32468906e198221ec0fe2b"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd770896c771306a6b6aecef46af0dee80407b2ce6a526078c15982cff263c54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8346a1a178e7ecc713dc2d93d76a2c9e10b9fd71f77a5d4bd4910ddcf903304c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a754e7956d16854cd183c15f0c0834b1691c94f520ecf4a5622f9d05388aa44"
    sha256 cellar: :any_skip_relocation, sonoma:        "809adc8fdca28cd5999f8747d5b42a3d2bdee861401d291e2deed5e70a9c3fa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8692d8612307c7399e17626295b6dd5780521f9aa98bb83f14b403de93d39851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "006c63dba64e9c3ab8df1c10113437e0650522665b49a8afd2b69aa860a2e168"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end
