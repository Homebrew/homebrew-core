class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.129.tar.gz"
  sha256 "8b7ad81805219e8b7ff52641f72eabd2312d91dcce4cb18f2c48c5e2729f53e7"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e968a4b7e0d3c67f3ce5768ae88737604288fa408a2c7ae4abd12eccd0671fc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e968a4b7e0d3c67f3ce5768ae88737604288fa408a2c7ae4abd12eccd0671fc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e968a4b7e0d3c67f3ce5768ae88737604288fa408a2c7ae4abd12eccd0671fc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a3cf4e41afa6f3cdc0358573fbed09f1adfe886e7a92200b493393948d858bc"
    sha256 cellar: :any,                 x86_64_linux:  "92b17a4bc75fbc87bfda22ad49368d8adb630ffe20acc0ecaafa329d3597bdc9"
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
