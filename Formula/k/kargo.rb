class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "9def8e58a6baa8e60dabf21e5288faf67878d4240b90c1551c320af4b0091242"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "490b478273843cf2464a3fccc23b4733f8952abbd1e94b78c450f92e305fd052"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "926d62f28ca022b030f5ef2b23bd62624f26824fe6719d329ac309b23f6ab680"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2c82f0709f1fb4202f4c4db4a3e253b0c346624bf01c9306b4b72ca139867ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "feadf4c76d9c961446c4679834f888c3017d3026269d9af1cb48b6b038e2bd64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23a36d46abb069153f92bdd851976023cd5f47fdff582e76a033fb73a3acfdd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f6a6bbaa3fd5a7a27cd874bef91cea5c55220200de4eef124f5f048d9367653"
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
