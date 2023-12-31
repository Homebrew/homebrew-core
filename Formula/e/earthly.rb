class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.7.23",
      revision: "e77372274b09b5e5f8a42f1b6ac264f7149c4924"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0aee363caa8fa581a21e38a45a2c5fb494d939d4db291b85297eeae5bb69eec9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0aee363caa8fa581a21e38a45a2c5fb494d939d4db291b85297eeae5bb69eec9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0aee363caa8fa581a21e38a45a2c5fb494d939d4db291b85297eeae5bb69eec9"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6e5b9db14819576844789d97c4b382b5636e5d0dd977fc3ed4174f26d04cf29"
    sha256 cellar: :any_skip_relocation, ventura:        "c6e5b9db14819576844789d97c4b382b5636e5d0dd977fc3ed4174f26d04cf29"
    sha256 cellar: :any_skip_relocation, monterey:       "c6e5b9db14819576844789d97c4b382b5636e5d0dd977fc3ed4174f26d04cf29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "549062b023d11cf06f54b903649126a14ec9c4ff739d06a367c617197c3c2974"
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
