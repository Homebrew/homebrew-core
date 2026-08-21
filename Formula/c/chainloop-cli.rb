class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.106.1.tar.gz"
  sha256 "457dcea244c32a73445f5a75d63c7e88467df68cde3208c819e715bf13ab726e"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b72d1b6ac37a6093d23ace03bf894827cb1bd67f2297ef6e8847f487fd97a4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b72d1b6ac37a6093d23ace03bf894827cb1bd67f2297ef6e8847f487fd97a4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b72d1b6ac37a6093d23ace03bf894827cb1bd67f2297ef6e8847f487fd97a4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b05dc8b0b607388dae81105ac9caefc3b503d50f3a8778cdcf96b16a01fe607"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c914f726cbf9eeaab973ca89879e3ef6c4bf2183dd11be9f98f832e1e03204c"
    sha256 cellar: :any,                 x86_64_linux:  "3649e8bd059e2c01f231fbfdd2355596cfe289a901b881893bd07988529abfe8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end
