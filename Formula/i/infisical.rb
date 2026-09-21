class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.133.tar.gz"
  sha256 "7938d4f0d0d87b1df17c5207ca3ef68634553d5f958f6efab8a85a567975a5d3"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bc29aa900ec9c4903280ebc30de12264adf19c4fd2d641b6bd0ffea6f84af87d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bc29aa900ec9c4903280ebc30de12264adf19c4fd2d641b6bd0ffea6f84af87d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bc29aa900ec9c4903280ebc30de12264adf19c4fd2d641b6bd0ffea6f84af87d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4558a009948528b171ebf4150ae158c6e8f90507dda94b92b8b7f868a12a2e15"
    sha256 cellar: :any,                 x86_64_linux:      "c38861d7490c9c579074a6181921e14db8b6e6e1d84460831050202727139075"
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
