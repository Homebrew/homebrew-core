class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.7.8",
      revision: "83add94bc251b22935fb492c08cd516556f03f7c"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "993b494ad2efb72e6f037b2bf3e07ec759fa95b9ef1dc91898c44d1c44e12157"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "993b494ad2efb72e6f037b2bf3e07ec759fa95b9ef1dc91898c44d1c44e12157"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "993b494ad2efb72e6f037b2bf3e07ec759fa95b9ef1dc91898c44d1c44e12157"
    sha256 cellar: :any_skip_relocation, ventura:        "1e896007c976aa8b0efdd98030192dc7bf354ba7968ddf8ce812deb7d696ea82"
    sha256 cellar: :any_skip_relocation, monterey:       "1e896007c976aa8b0efdd98030192dc7bf354ba7968ddf8ce812deb7d696ea82"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e896007c976aa8b0efdd98030192dc7bf354ba7968ddf8ce812deb7d696ea82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0e48b1c4e5d2adfd4343bcf2f2cc770d7d944341a45ce877bb2070c36ef07a2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version}
      -X main.Version=v#{version}
      -X main.GitSha=#{Utils.git_head}
      -X main.BuiltBy=homebrew
    ]
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork dfheredoc forceposix"
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
