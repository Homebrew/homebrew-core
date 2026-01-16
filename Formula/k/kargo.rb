class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "7162cdf57815d7cb84bdd14fee07436dffbdc8cfaf527969ff9473cc7a144d6c"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9a408015acf698436fa442fc04c398cf0ac697043c51a37d13bfcb93703ae3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fee72e0a137cd10e380c84035054cbaeeb29f9f1aab3c0c91852e1048188f0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5538c33c00cc105cc4761c14d327b29c4706458c9201a178a93a0c66c370c857"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a17ffdfc4f504a82758c7853004c42f323fea5d6f58d70f0f68862d2b18276f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f66051dc4a98fd29d1624c123eb8ad7508c0d18b63e2237c534e63cbf7e0d1d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3eb236145a452eefe5db30f605b21b36e9d3e58d50f167b0e7b7f808c110e31e"
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
