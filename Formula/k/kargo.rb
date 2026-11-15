class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.12.5.tar.gz"
  sha256 "bce87553c0f5327d6a5ee185941585d35e21d3fd97328b28e8a17170fb4cf85e"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "186e41e61526f133c72e27a4454c65073243ef860d6fb7a858f43c511409a663"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9f2316c2b754a7fd62ddf6578e47ce3304b2dc016c86b47cb437659d3b2d530e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1d7a9c5bb44aa861f19b5fd28b6b5ad486cd34c8b41d0315b05ad2da98b06bad"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f22f65e7f760f625fd56067f36f34be893c927eb263b10142ececb45e8fc33db"
    sha256 cellar: :any,                 x86_64_linux:      "563b555dedcf9297549ce2c72773ca53834c292825e458ca85299da62fd34f37"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
