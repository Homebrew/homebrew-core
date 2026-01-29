class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "097394d7d8a1d348d4ed9a4d9da1cc7cb7ae52aacdcfa75ce6c19ba85cdd9df8"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "490ef997e908bcb5579f666d0e4ecf8553042385c521f959510cb183fc68aee3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f5c9332baad3cdae479a940af10b275b840181d25b34a3f6ffeb886a3368a89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd6996c723df431d697b7b74008793e20c8a1929b1d28c74c8e370556408910b"
    sha256 cellar: :any_skip_relocation, sonoma:        "614238b8d0795189e1acea548e328196b0120fc1930aacc15ff7793096057c12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "063e7c3e22c593a7dddf8fb27e8b23ed8b63674a04f4f60115fd1808a38f169f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f056e59c48d96f21b2bc417bebf80ad2a3cd224806d413da4d311bda7af6172"
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
