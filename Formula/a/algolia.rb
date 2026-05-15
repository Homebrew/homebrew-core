class Algolia < Formula
  desc "CLI for Algolia"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://github.com/algolia/cli/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "eea57596e3db1a6c7432a4ed0c284184ebdb4135c819b5f3a82175bd8b343d27"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9df882746a827a6fd5bf55bbcbdf5b9c185026480910194d54c999b947da64a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9df882746a827a6fd5bf55bbcbdf5b9c185026480910194d54c999b947da64a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9df882746a827a6fd5bf55bbcbdf5b9c185026480910194d54c999b947da64a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1adeef4ecd1ff51176ef457ec8cbc72b6a7d1d30d3d1503dbc3004c8d6b5ac9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08a4bc724309c36e4816d872bae3c4b5a75d0073f0e07703ac822762ba17a7c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7602e742c1e0397e24ee093f957c15d5d22cb809b094b81bfc8313aa7f791b2a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/algolia/cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/algolia"

    generate_completions_from_executable(bin/"algolia", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/algolia --version")

    output = shell_output("#{bin}/algolia apikeys list 2>&1", 4)
    assert_match "you have not configured your Application ID yet", output
  end
end
