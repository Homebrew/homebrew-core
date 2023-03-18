class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.14.0",
      revision: "3f85048ecc6cc1c398eee9d311a5887da8d7eefd"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33e2041f8bca257d56e3252f4fb276066d05e52d9b10d6c61d3d217d9a7481f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2a24bbe43aeedfafd68127d1f07261945cb7db476e6e3bfffbdd3e8635b3794"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "021ee6bd19aa0f71037235a56141d8ac987e2730762107a93c8e868ef756e6e5"
    sha256 cellar: :any_skip_relocation, ventura:        "ee445b4f9088238fcbfb8ace6c80ee228feaecc0978b662a0a066d322da00503"
    sha256 cellar: :any_skip_relocation, monterey:       "156390bc4c07280639270ec6b292d8b5312ecbcc5dfacdfc82b8b82e08e70ac6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e61a5cb245f74601d6d403af927c4a69f5ceaa2acd1cad5f0756e674d41cf92b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fed05d5763c85f8abcba95acee4e6d5230160a1ed91dfde940be308ed073ded"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags: ldflags), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
