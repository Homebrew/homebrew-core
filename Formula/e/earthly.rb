class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.8.14",
      revision: "6b41f8409d7ffef0d25072c2c04250074b6e3c72"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8a06f6b5da950fcb246f19bd9137d667e69494cd763a1d533006e209ff8a218"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8a06f6b5da950fcb246f19bd9137d667e69494cd763a1d533006e209ff8a218"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8a06f6b5da950fcb246f19bd9137d667e69494cd763a1d533006e209ff8a218"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf4b0ca99ad2d1c42554d06c2d4304122eab48d2893aaaa7f2b351e1236de9cb"
    sha256 cellar: :any_skip_relocation, ventura:        "cf4b0ca99ad2d1c42554d06c2d4304122eab48d2893aaaa7f2b351e1236de9cb"
    sha256 cellar: :any_skip_relocation, monterey:       "cf4b0ca99ad2d1c42554d06c2d4304122eab48d2893aaaa7f2b351e1236de9cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22d0f5cca2f253ccaef03c77c30ecdd31eb260a93bd6854852eb6c9aca27c4ca"
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
