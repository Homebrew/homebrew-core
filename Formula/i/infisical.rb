class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.45.12.tar.gz"
  sha256 "510a7c65e79c115515cdb647add1e148c1d7e9f5d7bfc66c50d258f8d0acb1e3"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "efb15c9e6fc4e3aa621d27961dd76e1e95724632d8507310652a89c0d1122413"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "efb15c9e6fc4e3aa621d27961dd76e1e95724632d8507310652a89c0d1122413"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "efb15c9e6fc4e3aa621d27961dd76e1e95724632d8507310652a89c0d1122413"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6827f1961fc9e646319ab46e13c8d4de7fac6f419b8dc4fc3ca5b5d42f4b310d"
    sha256 cellar: :any,                 x86_64_linux:      "18efdd83fd4036a27bef8054181609a0a194ceec688d19e8fb800a579748225c"
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
