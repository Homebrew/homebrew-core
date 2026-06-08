class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.10.5.tar.gz"
  sha256 "a4e9810b5f7b07b43772bf03425906534b659eee45d8f52f8bae43d8408841b3"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6b796b1c50c139a43e6c10f94d4e5089c1dae2945ab03bd498a6b7d73211600"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99f1f466b7cc6c165aa5e2f6f1a872e30bb5a10f322da1f6eb2c42197cdeb4b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e1cf604421a5d0d002c6f40cd83fd900c6135b2ea924429fb2fd61040a49927"
    sha256 cellar: :any_skip_relocation, sonoma:        "050d0b7850f66647ad747c7fbc69a315fa828c6b5abe81bac4148034e5d524f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7816caa43c4560d33718d4c09f74ccc3430e63feca6aa11e155fc4d30a5d672e"
    sha256 cellar: :any,                 x86_64_linux:  "43267a15ec6e754eb88e4382dff3d4cd7d914600ca956003a7575da624666a2a"
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
