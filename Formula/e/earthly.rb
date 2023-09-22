class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.7.19",
      revision: "f379f768ffee3e71e80ae196611dd6b798937277"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e61da47c2af0dbb81ddf8cad72b55be0d2e1b346a08c7e93018897914d0f11f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e61da47c2af0dbb81ddf8cad72b55be0d2e1b346a08c7e93018897914d0f11f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e61da47c2af0dbb81ddf8cad72b55be0d2e1b346a08c7e93018897914d0f11f"
    sha256 cellar: :any_skip_relocation, ventura:        "ef64c705751c0e1b46a24e54508352c889173046a55141357f2b7b4650f268d5"
    sha256 cellar: :any_skip_relocation, monterey:       "ef64c705751c0e1b46a24e54508352c889173046a55141357f2b7b4650f268d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef64c705751c0e1b46a24e54508352c889173046a55141357f2b7b4650f268d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7067bfa95a2c39d7c1c7fa887775a46e01a6ca968243634d3e5bbf3362500e8"
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
