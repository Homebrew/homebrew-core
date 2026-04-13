class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.72.tar.gz"
  sha256 "4b827eeaa39b98545043f8b9114c5577a125e8ebb6261be7f3dc133a8ad03c71"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7419b3b2a4ce2b4d2c3b8352378fbf85d1430a9b91cae2c5281e679874fd270"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7419b3b2a4ce2b4d2c3b8352378fbf85d1430a9b91cae2c5281e679874fd270"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7419b3b2a4ce2b4d2c3b8352378fbf85d1430a9b91cae2c5281e679874fd270"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb690f2c1e195a50ed73cb3cbc7d512f6195c34c1e08e6294cc73596bf1b058f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae94b73d433dc9c67ee8e32a0efae63f70a555b2f295b170dff55326658cb329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cbd39df5aa1794bc736d63f75707897420c5d4faf1eb9995d7ca5fe50bf4b8f"
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
