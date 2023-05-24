class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.7.6",
      revision: "78d2f5be89c8ada1048ed7130ed319948bf79912"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67e59197c18ae906882886dd6292c4bb18fe2e3c16c034285bcecb632dff95b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67e59197c18ae906882886dd6292c4bb18fe2e3c16c034285bcecb632dff95b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67e59197c18ae906882886dd6292c4bb18fe2e3c16c034285bcecb632dff95b0"
    sha256 cellar: :any_skip_relocation, ventura:        "f54dbe1163ac3ec8f813ee56aa4994b518f062cd0ee9b1df6c8ced3a905878f0"
    sha256 cellar: :any_skip_relocation, monterey:       "f54dbe1163ac3ec8f813ee56aa4994b518f062cd0ee9b1df6c8ced3a905878f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f54dbe1163ac3ec8f813ee56aa4994b518f062cd0ee9b1df6c8ced3a905878f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e008adc86fac4072e85fe1980ec146c3b1c01b0feb1a276037675c9781a1049b"
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
