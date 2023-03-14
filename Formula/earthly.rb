class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.7.2",
      revision: "e6fed708700425fc2616bd1e7a0f202d414f5f23"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4520ce916bc4fdfecb5c2a18ba5ebd21544eca63f3fd75e6b2aeda9733408193"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4520ce916bc4fdfecb5c2a18ba5ebd21544eca63f3fd75e6b2aeda9733408193"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4520ce916bc4fdfecb5c2a18ba5ebd21544eca63f3fd75e6b2aeda9733408193"
    sha256 cellar: :any_skip_relocation, ventura:        "84df193100b8611ef0cd7e40109282d8a1d75609ef2856576c049956e697b470"
    sha256 cellar: :any_skip_relocation, monterey:       "84df193100b8611ef0cd7e40109282d8a1d75609ef2856576c049956e697b470"
    sha256 cellar: :any_skip_relocation, big_sur:        "84df193100b8611ef0cd7e40109282d8a1d75609ef2856576c049956e697b470"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08536ec6d7d54cc1fbef9c7d435aafe2c10f0fe6ffb6afa1429df3513485821f"
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
