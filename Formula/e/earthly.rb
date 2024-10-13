class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.8.15",
      revision: "cb38f72663696d17d8393b1cc8bac66aed28faa2"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e048169778f8a017306c4f876cd4e36fb3e7bfe809a2e1fa5036545397d319a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c80c3a761809ed97b83029dc4e4f39cc90cc99dad895db238599a378ffb139a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c80c3a761809ed97b83029dc4e4f39cc90cc99dad895db238599a378ffb139a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c80c3a761809ed97b83029dc4e4f39cc90cc99dad895db238599a378ffb139a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "24570e41843f45493539397ef7a9cb9533d581418b1dc44908690fb032c716f4"
    sha256 cellar: :any_skip_relocation, ventura:        "24570e41843f45493539397ef7a9cb9533d581418b1dc44908690fb032c716f4"
    sha256 cellar: :any_skip_relocation, monterey:       "24570e41843f45493539397ef7a9cb9533d581418b1dc44908690fb032c716f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3c89999c25f245dcd4e4e2b946ac4902c7cfe4b3c60a31edf19fe6f30453911"
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
