class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://github.com/launchdarkly/ldcli/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "aa7fbdc5c952abfa49c6391f1f4f8307da598cef9305178b0785cc4d50ec597c"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57424741ba85872b09f178749332d33503eb3429ca50160dddc2fb34b9310e61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99252847a6c42cdb0cd2dcee7d05b63fa9f3f3edc11666f215e861b38ea9e8d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce2224a3cf9bbf7b0464b48148c6ed8769e9e938de2c8d8fad7b11f8984592bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "4093b480ee0dd39170cbc01ed9ea2c335a18def939cb4b607af8f0e36aa6a782"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87653af1f470e2bda37abf8fe41e10cb2d4aa083ac530bd419fa1c1c2555fa18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcc22492c537d7ca71562bdba5c8b302a106212d6c02972c2298ffc253fa9f32"
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
