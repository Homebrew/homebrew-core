class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.7.15",
      revision: "ae8f65528ad37a278985de2e234deb42b91e308f"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3894af687c33a70c85d390e3313dd8cc60ab7e6b6d07405a281907d98e8311c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3894af687c33a70c85d390e3313dd8cc60ab7e6b6d07405a281907d98e8311c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3894af687c33a70c85d390e3313dd8cc60ab7e6b6d07405a281907d98e8311c8"
    sha256 cellar: :any_skip_relocation, ventura:        "48acf41d65882bade70668dcd76e523a2cd9d9864fc6d46926f4196819f37089"
    sha256 cellar: :any_skip_relocation, monterey:       "48acf41d65882bade70668dcd76e523a2cd9d9864fc6d46926f4196819f37089"
    sha256 cellar: :any_skip_relocation, big_sur:        "48acf41d65882bade70668dcd76e523a2cd9d9864fc6d46926f4196819f37089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2e4dc634faec4c78790937af32ecffe0e940490ae48a69c4a2be02a4a0c9c33"
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
