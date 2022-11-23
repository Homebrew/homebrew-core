class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.6.30",
      revision: "743687991d227f2f7e2e6ba11a90f443b4f99c67"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e576fe99c01952c27a0cb9ac61ade2c08b976dca197ed080e51852da1682098d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e576fe99c01952c27a0cb9ac61ade2c08b976dca197ed080e51852da1682098d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e576fe99c01952c27a0cb9ac61ade2c08b976dca197ed080e51852da1682098d"
    sha256 cellar: :any_skip_relocation, ventura:        "c12731381bb5ba4abd20324e7bb0e2b200c859b874cd437596b3af5bc73436ed"
    sha256 cellar: :any_skip_relocation, monterey:       "c12731381bb5ba4abd20324e7bb0e2b200c859b874cd437596b3af5bc73436ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "c12731381bb5ba4abd20324e7bb0e2b200c859b874cd437596b3af5bc73436ed"
    sha256 cellar: :any_skip_relocation, catalina:       "c12731381bb5ba4abd20324e7bb0e2b200c859b874cd437596b3af5bc73436ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68c6f5bd789ba2b3ca424bbe2046c8154777f164d2abeb9bb94dbc71a4b3ff29"
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
