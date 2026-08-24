class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.125.tar.gz"
  sha256 "e73ed59c9485f113045f018c6cbc62e99afef0b8277f81cd6de16599aabcf1a6"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21cb4463ddf2cbd775e70e0e5ceb417189e437043f545e78c8c3a433be766c0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21cb4463ddf2cbd775e70e0e5ceb417189e437043f545e78c8c3a433be766c0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21cb4463ddf2cbd775e70e0e5ceb417189e437043f545e78c8c3a433be766c0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "77db0f7d728f7a0395b44e48e3a1dfd336fd06975ece073bea1778884fbc72b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c0d410c5fcae54604f4eb9471d9da4a584909c4d5c03f31d121d26c8aae4ba2"
    sha256 cellar: :any,                 x86_64_linux:  "f6cbfe9ba613b8aec42faaecccb302684213971a0180f86a6b2cb7d9b31621b2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
