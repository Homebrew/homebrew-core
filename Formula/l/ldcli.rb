class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://github.com/launchdarkly/ldcli/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "29d6735dc5c04cfa9d9c919d4ab5e81aa845b8ac9cddab51943de4c280d4f227"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec1b1867320ba9032ca9c32aa8394b0baea12301ec70d8c6d5184641fd91196a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c732db99cf58e37b5cda28b4917d1ec6a7b6dd8b7869e15f626d0fd9122b6bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00bafd0f811459c2403fa6d152ddbba2c4800859bcc0695b8158b92850531e16"
    sha256 cellar: :any_skip_relocation, sonoma:        "58b82fe075d19e85212f8126e539304fe02974f9b4677251efb7e537e5ff6c6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "807f4ff4a5ce637d226b604acf5e77df1d4c7a9caf72ca58f3c971001bf8a3ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8181615a977912bf099cf8fb7e9b9d961366b457c94450ea89b332ed6424bde9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ldcli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    output = shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1", 1)
    assert_match "Invalid account ID header", output
  end
end
