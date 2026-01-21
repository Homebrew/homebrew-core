class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.48.tar.gz"
  sha256 "6894f6a687fb7efcfdb0cfecd715e4b69848b6edd715a5065273ea11856cbbee"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04ca5a640b27ee070157635733452413dfbc618aa8072032a988534106e88221"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04ca5a640b27ee070157635733452413dfbc618aa8072032a988534106e88221"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04ca5a640b27ee070157635733452413dfbc618aa8072032a988534106e88221"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e5288f4f9ce0285a980dbce855f2459c52fef605679903cd24405b336c9db7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "041ddaf5ef427af2856c3a213a0e8b6ef26ce63e021602a549a3c9411c6e0529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a03996b30aec92a1b6052500fd45ca5097812170d22d9dcaf19ee64dcb59098a"
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
