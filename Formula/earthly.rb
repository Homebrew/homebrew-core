class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.6.23",
      revision: "d6f689104aaaf38178a3f58e1a969eacded7341d"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8470876c55fd0f44f30e9917750d3f44484c7d929915f3a291334677c25e3bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93ec045558aea1b1e1a91064775aebe71f93079473936668a38620ca27c3a102"
    sha256 cellar: :any_skip_relocation, monterey:       "aefaa2826207b4fdfde276cbab179004538ccea0dec051b0bc99d6f0186bf131"
    sha256 cellar: :any_skip_relocation, big_sur:        "04d0c548112e96ea38937e3c3ffd98b34435b6421e21d7ecb55fae2ec8524660"
    sha256 cellar: :any_skip_relocation, catalina:       "a0a69da13ab3e9ea5501787d169e5520445b588773a532528d43a308627fd89c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92d35c0c50f2d545d2568761d0f0d0b47d485fbc74d3b2ff684c96428907ae76"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version}
      -X main.Version=v#{version}
      -X main.GitSha=#{Utils.git_head}
      -X main.BuiltBy=homebrew
    ]
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork"
    system "go", "build", "-tags", tags, *std_go_args(ldflags: ldflags), "./cmd/earthly"

    generate_completions_from_executable(bin/"earthly", "bootstrap", "--source", shells: [:bash, :zsh])
  end

  test do
    # earthly requires docker to run; therefore doing a complete end-to-end test here is not
    # possible; however the "earthly ls" command is able to run without docker.
    (testpath/"Earthfile").write <<~EOS
      VERSION 0.6
      mytesttarget:
      \tRUN echo Homebrew
    EOS
    output = shell_output("#{bin}/earthly ls")
    assert_match "+mytesttarget", output
  end
end
