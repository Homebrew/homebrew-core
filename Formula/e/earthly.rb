class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.8.5",
      revision: "a6b5b8dca64fdae64f089ac48cefa60ab39974c4"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f3ba059d98a51acef5ef0b894643d974692abdabfe45715bf68642d98214223"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f3ba059d98a51acef5ef0b894643d974692abdabfe45715bf68642d98214223"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f3ba059d98a51acef5ef0b894643d974692abdabfe45715bf68642d98214223"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a97a804b09353fe47d64b7cb238e8446fba28b44e2e3b79d01983e1f2e1fcb7"
    sha256 cellar: :any_skip_relocation, ventura:        "4a97a804b09353fe47d64b7cb238e8446fba28b44e2e3b79d01983e1f2e1fcb7"
    sha256 cellar: :any_skip_relocation, monterey:       "4a97a804b09353fe47d64b7cb238e8446fba28b44e2e3b79d01983e1f2e1fcb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c943292d28b063a19c39601bda997456d9dcd8f7fd33ea3a1b24901dc06e7f5"
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
    system "go", "build", "-tags", tags, *std_go_args(ldflags:), "./cmd/earthly"

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
