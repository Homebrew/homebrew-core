class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.27.tar.gz"
  sha256 "14833406adebfd9eec569bfb6315ac008f09d72e279d226b7bce0c8abfe6d18d"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7cbe68ad04b0b90b0f1ab2a936dad69125063ad17025ff231ff6181bd77e39b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7cbe68ad04b0b90b0f1ab2a936dad69125063ad17025ff231ff6181bd77e39b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7cbe68ad04b0b90b0f1ab2a936dad69125063ad17025ff231ff6181bd77e39b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bd5cbbb8f786be8b88face19be6570d2c1bdd2c1ababaaef019e9d011f2ca7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e46fcbd15d7974080e434ae1404fbad7acb93d8a704e91b50ad407fb89981e12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c75c83acc01281fd7749eb6e60fe766e4340e149871cded2093365508723dca3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
