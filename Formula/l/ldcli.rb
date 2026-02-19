class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://github.com/launchdarkly/ldcli/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "45d9ae189c1b19410f75bed6eb6bfc82aa7e003b5974140fc90b4349f3f7801b"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7004f7a67cb01cbce7ceaa21536f4bfa0e2b14219d6214365ad51df95e3b2ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aff4c8364c01e798defd90f87baf2e818d89c6bf9f3927c74bb01ecb6a08fc1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b239ea6da177122aa8d5d84f275671e2e4d9c751760623e4bfc4ffaf45d9681"
    sha256 cellar: :any_skip_relocation, sonoma:        "03a82eb143b2761f2a69811dbbe464ba62b9c8a59081ea363189d55305f0f4c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a33342587b1859364b3e15c4c4427d0768969ef0ebf7ca4fe3dbce5da4ee80cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06c00ab729f449dbba2aa27c3d730e62cdf1ad720a68c5b39980d3a5c521b935"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ldcli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    output = shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1", 1)
    assert_match "Invalid account ID header", output
  end
end
