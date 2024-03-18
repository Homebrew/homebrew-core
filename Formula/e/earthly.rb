class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.8.6",
      revision: "b20c1db1cfe5816a5d2f7d416d598d5777d8f4bb"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08efcf29f75abfab2403bc12d942875cbecc2af24b662381bc0097a73ed0b803"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08efcf29f75abfab2403bc12d942875cbecc2af24b662381bc0097a73ed0b803"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08efcf29f75abfab2403bc12d942875cbecc2af24b662381bc0097a73ed0b803"
    sha256 cellar: :any_skip_relocation, sonoma:         "19ea1f927c4a690daac97dc0bb8d146d118031820ddcd58f59f2ade66b895f74"
    sha256 cellar: :any_skip_relocation, ventura:        "19ea1f927c4a690daac97dc0bb8d146d118031820ddcd58f59f2ade66b895f74"
    sha256 cellar: :any_skip_relocation, monterey:       "19ea1f927c4a690daac97dc0bb8d146d118031820ddcd58f59f2ade66b895f74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3162fca87309b1ccc3cb028f36789181ae47f0bcb080e6a139272c7f75bbc19"
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
