class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://github.com/lacework/go-sdk"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.17.0",
      revision: "df0ba0485df770e16ce70329796283ea7dced13d"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6161c2153a7402296dd623b2ce12fd89eb467aeef83491802c3fe1655a3b9199"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6161c2153a7402296dd623b2ce12fd89eb467aeef83491802c3fe1655a3b9199"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6161c2153a7402296dd623b2ce12fd89eb467aeef83491802c3fe1655a3b9199"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f9a2c9a61d75647bc0c4df38ef5bf38ef40b1e4f30134745112ff0a9108942ad"
    sha256 cellar: :any,                 x86_64_linux:      "5859129717df889bd1a89e1efac8981d5ccc57d427d7c479bbb44a5589dd139b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/lacework/go-sdk/v2/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/v2/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/v2/cli/cmd.HoneyDataset=lacework-cli-prod
      -X github.com/lacework/go-sdk/v2/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags:), "./cli"

    generate_completions_from_executable(bin/"lacework", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
