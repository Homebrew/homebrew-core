class Mods < Formula
  desc "AI on the command-line"
  homepage "https://github.com/charmbracelet/mods"
  url "https://github.com/charmbracelet/mods/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "f0eb5a941c261a55a290b1b99fd09e8f07abd3394b532bf76493376d8ce7967d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1da4c12df447d0b3b60bac95a0eda5687c6f403b0e9be6af727685b7df47bac8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4938a1e13494d66498a54951f8f4f0308fecd43da9584f6947394fd87924d5a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "add7098672318bda70dd94b7d7d59738b76b93545fa23c499b4e2006b5d2525c"
    sha256 cellar: :any_skip_relocation, sonoma:         "be4d80dacc4bc46257a58a70c8079b164f7910d419e8a0a37b72dae2b72f4367"
    sha256 cellar: :any_skip_relocation, ventura:        "88bb50407edaf8ddebab691fbd117009935cf9669caafb682fbbabf2908151af"
    sha256 cellar: :any_skip_relocation, monterey:       "47f08ba1647685aff903f074cc324888c9ace645c83e3467caf083d119790fd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21c802d62b15ae07b2788ffc5caa1ac0a1f6786d45f1ca0ac0038938557d7040"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.CommitSHA=#{tap.user}
      -X main.CommitDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["OPENAI_API_KEY"] = "faketest"

    output = pipe_output(bin/"mods 2>&1", "Hello, Homebrew!", 1)
    assert_match "ERROR  Invalid openai API key", output

    assert_match version.to_s, shell_output(bin/"mods --version")
  end
end
