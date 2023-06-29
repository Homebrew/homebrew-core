class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.7.9",
      revision: "cf170dbe5514ed18ae6cab778aafcde3594470bb"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "feaf989cedb7d4786849f5b13954d3d2b329800e7d87438692c954eb6e596c68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "feaf989cedb7d4786849f5b13954d3d2b329800e7d87438692c954eb6e596c68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "feaf989cedb7d4786849f5b13954d3d2b329800e7d87438692c954eb6e596c68"
    sha256 cellar: :any_skip_relocation, ventura:        "902db2893e96ab2744151b2e706dde226a6de0374bbad81fbfd9f66f6d743ef6"
    sha256 cellar: :any_skip_relocation, monterey:       "902db2893e96ab2744151b2e706dde226a6de0374bbad81fbfd9f66f6d743ef6"
    sha256 cellar: :any_skip_relocation, big_sur:        "902db2893e96ab2744151b2e706dde226a6de0374bbad81fbfd9f66f6d743ef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28df00c14acd066872c95879cc98488b0013d4e90e1859b3a673c4ffdde0d2c5"
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
