class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.45.7.tar.gz"
  sha256 "1f846c140fa57958ceef7f5bd0c6aebf18bd99c7038baf16427826da112e14d9"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f36229429d180d6bef0360eb93d550e99eaa19e8ef07b40395942f1e2e785c60"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f36229429d180d6bef0360eb93d550e99eaa19e8ef07b40395942f1e2e785c60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f36229429d180d6bef0360eb93d550e99eaa19e8ef07b40395942f1e2e785c60"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "df6da6be4d188b13e4380cb41293534d229e091b19a5fd64929d24b061cfaddd"
    sha256 cellar: :any,                 x86_64_linux:      "f21c83c90e55b79602b12fccc989e7456332194aecce3cc5b82edb316919264b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
