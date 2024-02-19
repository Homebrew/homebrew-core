class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.8.3",
      revision: "70916968c9b1cbc764c4a4d4d137eb9921e97a1f"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b3a10e198298e8f97c6092532e07fb5ea0e199f49857eecaf709586dd0a3e91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b3a10e198298e8f97c6092532e07fb5ea0e199f49857eecaf709586dd0a3e91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b3a10e198298e8f97c6092532e07fb5ea0e199f49857eecaf709586dd0a3e91"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3b0997f3ad01c5f0e3338cbc7fb293f801163d40c359d9fbbeff12f86e7fb12"
    sha256 cellar: :any_skip_relocation, ventura:        "b3b0997f3ad01c5f0e3338cbc7fb293f801163d40c359d9fbbeff12f86e7fb12"
    sha256 cellar: :any_skip_relocation, monterey:       "b3b0997f3ad01c5f0e3338cbc7fb293f801163d40c359d9fbbeff12f86e7fb12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa6802b53a916700f8a22989e94cbb1a1841ecd30443bad993687c0d00450197"
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
