class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.8.9",
      revision: "a2fc61ee6e00ed5b8ad09bd06c59451534e2541e"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff1d78fde25c19a2aff63e9d9b85f75d3e1f29baf1bdcb3c9a5a9076f013db2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff1d78fde25c19a2aff63e9d9b85f75d3e1f29baf1bdcb3c9a5a9076f013db2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff1d78fde25c19a2aff63e9d9b85f75d3e1f29baf1bdcb3c9a5a9076f013db2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f94ffa3852e363fa2331d2ac5b361c61b26a6200b517a09a3a36a13eb5383a23"
    sha256 cellar: :any_skip_relocation, ventura:        "f94ffa3852e363fa2331d2ac5b361c61b26a6200b517a09a3a36a13eb5383a23"
    sha256 cellar: :any_skip_relocation, monterey:       "f94ffa3852e363fa2331d2ac5b361c61b26a6200b517a09a3a36a13eb5383a23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07b7e05ae674788c2fe44a4ef5417cf7e6dd22bef3afbf4216c9195103c97e92"
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
