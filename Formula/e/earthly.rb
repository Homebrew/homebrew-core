class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.8.6",
      revision: "b20c1db1cfe5816a5d2f7d416d598d5777d8f4bb"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9893d84394277081025e92306b212d910b32567ed3ad294b5daa66b4214d4378"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9893d84394277081025e92306b212d910b32567ed3ad294b5daa66b4214d4378"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9893d84394277081025e92306b212d910b32567ed3ad294b5daa66b4214d4378"
    sha256 cellar: :any_skip_relocation, sonoma:         "77b18e3ab60252298f77e13d11a28b6d0187dbb8f80ebdda3b287dac09b628ce"
    sha256 cellar: :any_skip_relocation, ventura:        "77b18e3ab60252298f77e13d11a28b6d0187dbb8f80ebdda3b287dac09b628ce"
    sha256 cellar: :any_skip_relocation, monterey:       "77b18e3ab60252298f77e13d11a28b6d0187dbb8f80ebdda3b287dac09b628ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02588b0161a22c9f9c1fa2340ed5dc0f92988f3a73b02a3fdb702162a5b9bef2"
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
