class HarborCli < Formula
  desc "CLI for Harbor container registry"
  homepage "https://github.com/goharbor/harbor-cli"
  url "https://github.com/goharbor/harbor-cli/archive/refs/tags/v0.0.27.tar.gz"
  sha256 "b8661164e532471e1cfcd74d5447c69648924a501a628a8b8322c4facaefb17b"
  license "Apache-2.0"
  head "https://github.com/goharbor/harbor-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7e1fee4566243a5ecc79eac048c355eaf8675933aa1b07d45dd97cfc3764f298"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2aad6ee9ff1b0fb3cbcdb37f96b274a13d0de86f9b65a841621a847177feca33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "199791643c4cf617a583a14088b71b9c5b78e75e4018742cc7252b059ea7ce9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7b286359b013a340647a2363a8553d41befd069927e7c27f79ff4c068535b0ff"
    sha256 cellar: :any,                 x86_64_linux:      "1bdf520456df029136dde1ad3b4a7cc48c6d86f187231b0c0b5ad05b789ef770"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.Version=#{version}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.GoVersion=#{Formula["go"].version}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.GitCommit=#{tap.user}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"harbor"), "./cmd/harbor"

    generate_completions_from_executable(bin/"harbor", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/harbor version")

    output = shell_output("#{bin}/harbor repo list 2>&1", 1)
    assert_match "Error: failed to get project name", output
  end
end
