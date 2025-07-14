class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.3.2",
      revision: "9b58aa647fa955b2fdf21fb17c114f5895a30bbd"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c1d2bfebce4ea7d892480733e5b8fc9f13062be20f0c11d5fa499e57de6dc21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c1d2bfebce4ea7d892480733e5b8fc9f13062be20f0c11d5fa499e57de6dc21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c1d2bfebce4ea7d892480733e5b8fc9f13062be20f0c11d5fa499e57de6dc21"
    sha256 cellar: :any_skip_relocation, sonoma:        "d99f3e493a6ba1cee05ea55ee136acbd01c8023124512800c9c70956ed9d5f30"
    sha256 cellar: :any_skip_relocation, ventura:       "d99f3e493a6ba1cee05ea55ee136acbd01c8023124512800c9c70956ed9d5f30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dfdc3650e5fe819502922b51bbeac83d76ee7a89982ab4bce3934f35b3ae264"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/v2/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/v2/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/v2/cli/cmd.HoneyDataset=lacework-cli-prod
      -X github.com/lacework/go-sdk/v2/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags:), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
