class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.44.15.tar.gz"
  sha256 "41db66daaf1d363b883b19a3a05486a80677aa61edb110d307b1eff47d5d7ad7"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2dc0ee9511d7777feb4e5418c9cecbfa9785f3abfd6e28b45a9b7003299c5078"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2dc0ee9511d7777feb4e5418c9cecbfa9785f3abfd6e28b45a9b7003299c5078"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2dc0ee9511d7777feb4e5418c9cecbfa9785f3abfd6e28b45a9b7003299c5078"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "998358e3e1b15bc76f8f691b46437c2bd48b1ed9703ef925509f7a0539c06e88"
    sha256 cellar: :any,                 x86_64_linux:      "75bc609f756f91395b737661315d58db1bc932a50dc38366b6f37f53872aeea0"
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
