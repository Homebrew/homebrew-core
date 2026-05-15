class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.84.tar.gz"
  sha256 "c051f497b71d0ef4ac9a4316f82713bb691bc7d626e11467ab170b0610fa5f9c"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1bb33e9383a8510e7f9ede0d7ba6aa27896d359dd05d9d1dc24136941ff4a63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1bb33e9383a8510e7f9ede0d7ba6aa27896d359dd05d9d1dc24136941ff4a63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1bb33e9383a8510e7f9ede0d7ba6aa27896d359dd05d9d1dc24136941ff4a63"
    sha256 cellar: :any_skip_relocation, sonoma:        "f92ea776df88588ebed3e647f704e930b6b4b3d998209ea7f86e220a1d46c4f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "012c3d3f9b32e0ea97ff73cdcd6155af0050b8b5f89b42967e0e8e32551a82ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81cc406efc298278e6d1e54f9a93f5715d0c9d5399b8049ec21ed9edc093f106"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
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
