class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.78.tar.gz"
  sha256 "b6b722bd4db503073a10fbdd23f5fb87d41788e6121826c292a118b520e2c2cf"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c9d583c2c0a9c6d4eb623ca23df7f1d785f8c11839b62db353c0adf022f6379"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c9d583c2c0a9c6d4eb623ca23df7f1d785f8c11839b62db353c0adf022f6379"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c9d583c2c0a9c6d4eb623ca23df7f1d785f8c11839b62db353c0adf022f6379"
    sha256 cellar: :any_skip_relocation, sonoma:        "c97194c5a6a9531a80f0832231d7dcbb2d7648b52078421f8f78ffd151fc4c06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7317d79ceb32a3e1ab8e5c4412c7481f1a995c8f310b17162989746baddf2605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd70dee467db521dc22edee198702cb29992394998c2aa821e5b6e4af2d78903"
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
