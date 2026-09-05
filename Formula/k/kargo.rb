class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.11.4.tar.gz"
  sha256 "06af0413397fbf482b311e11e016dde82626fcc7f35f39b933c20a45b214825c"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30f8f3fbcc253ff74a595c76a4a6619d81f120e3b2d7acb1573f15fc85741034"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f3820e8540106defa5596054ba43c73bf0337174f13a0ba5650cc3023a51648"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e3d0e7da62be01ba44cb3c341338c6127c078c1ac345db8107722c155c58587"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e602f1fb01f97f13db61e08b03c1a115b4c27007294909d6a291d1e986b232f"
    sha256 cellar: :any,                 x86_64_linux:  "2ee9d525e22706edaeea6f0eba00a03e66ca408e8f32aaa4feef49749353e223"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
