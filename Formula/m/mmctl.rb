class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v11.1.0.tar.gz"
  sha256 "2407a0d4e982a492abc6b63b6d062358b17da2108505aaa1b4b5f99e39afc56a"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "148cc666ad1b88f578adda98506f61e6a8b1d068feb35b7e8ea5bfad7ad37431"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "148cc666ad1b88f578adda98506f61e6a8b1d068feb35b7e8ea5bfad7ad37431"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "148cc666ad1b88f578adda98506f61e6a8b1d068feb35b7e8ea5bfad7ad37431"
    sha256 cellar: :any_skip_relocation, sonoma:        "75597e297b4e16b0f7a9bcc5e825c8451e9387611d9082230d27d25e76cf29be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e88028e71ab2bbcd18e2463cf5c07d980cf930292324dffc682c59bb205ab925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5756b40965cea5e8d1d99150e7c2eca69c3efc257136fa7c9f9a601d9bdc38b7"
  end

  depends_on "go" => :build

  def install
    # remove non open source files
    rm_r("server/enterprise")
    rm Dir["server/cmd/mmctl/commands/compliance_export*"]

    ldflags = "-s -w -X github.com/mattermost/mattermost/server/v8/cmd/mmctl/commands.buildDate=#{time.iso8601}"
    system "make", "-C", "server", "setup-go-work"
    system "go", "build", "-C", "server", *std_go_args(ldflags:), "./cmd/mmctl"

    # Install shell completions
    generate_completions_from_executable(bin/"mmctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end
