class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.6.28",
      revision: "3c679c49e481032f2dd01163f2768b24a360eb2f"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16ece29861a61094359f085f2a38c28a9bce652f7d1b23a0a610178c6454b78b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd5ceb35220401e5cefbcc0e2cfe07585e8ce60a1074cbb28b7493e0637abc08"
    sha256 cellar: :any_skip_relocation, monterey:       "05b8dfd50d2e8e5bee97de9026a181c8522eef84a99ffe61c08dfc5ca5c3fc7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f640c13e395eabfea11690f4d325cddca4f0eacd201839f37787930f88e05ecd"
    sha256 cellar: :any_skip_relocation, catalina:       "e6e882d474c9d367ffa29ab41221ffa4daef11ab92455ac7b747f65841902b75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97d1b9264d289711162f63c298f47e19e139a3f437b3ea693d2a5e1a7494bf53"
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
