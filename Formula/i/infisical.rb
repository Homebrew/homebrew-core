class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.77.tar.gz"
  sha256 "7e1a69b450676d5243e96eda2beb67c51cddceb4dcc2576c790f26dff32681b8"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0560295adfd1b3af19bd095f1b71a64d518e46c30bf79e65b1e0dc9cf8af5ad9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0560295adfd1b3af19bd095f1b71a64d518e46c30bf79e65b1e0dc9cf8af5ad9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0560295adfd1b3af19bd095f1b71a64d518e46c30bf79e65b1e0dc9cf8af5ad9"
    sha256 cellar: :any_skip_relocation, sonoma:        "003cf95b7c9390ce6bea5309f2ec00207c2582da4e416c50cf078d0ac6b2bb16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb6b002f1e0e8b707cd924c3a48ca90a86db03a7fc057c8727160bc91df2478e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fef1216b57c3546b2856c84eed0ff43165a9d2009e2044fc30df3edbdb64c762"
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
