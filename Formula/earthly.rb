class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.7.2",
      revision: "e6fed708700425fc2616bd1e7a0f202d414f5f23"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f101ec846915c9cf8dc5f36554b9dd20f22d9a6f3701c522f8d5c1e366f67451"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f101ec846915c9cf8dc5f36554b9dd20f22d9a6f3701c522f8d5c1e366f67451"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f101ec846915c9cf8dc5f36554b9dd20f22d9a6f3701c522f8d5c1e366f67451"
    sha256 cellar: :any_skip_relocation, ventura:        "bc85d0b27e71b8d80f58c54c8f42349bfec1607d73793732900feb1fc17650cf"
    sha256 cellar: :any_skip_relocation, monterey:       "bc85d0b27e71b8d80f58c54c8f42349bfec1607d73793732900feb1fc17650cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc85d0b27e71b8d80f58c54c8f42349bfec1607d73793732900feb1fc17650cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2aa1cda3f35330739c397e821f6dd0524fe072b0d7f6558e994026830cabea6"
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
