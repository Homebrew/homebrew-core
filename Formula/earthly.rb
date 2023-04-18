class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.7.4",
      revision: "a1c46ca2b75f21a4948fd53b5464de5a2bd90372"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e3fba10c5a48f9cdd462b4ee22c197b7fb1ecbf66495d539debbc38e81bace3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e3fba10c5a48f9cdd462b4ee22c197b7fb1ecbf66495d539debbc38e81bace3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e3fba10c5a48f9cdd462b4ee22c197b7fb1ecbf66495d539debbc38e81bace3"
    sha256 cellar: :any_skip_relocation, ventura:        "b9685ab9f9dfab892fa58c84609d8de227903a975aba984ace103368e351c588"
    sha256 cellar: :any_skip_relocation, monterey:       "b9685ab9f9dfab892fa58c84609d8de227903a975aba984ace103368e351c588"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9685ab9f9dfab892fa58c84609d8de227903a975aba984ace103368e351c588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bf4a346196981992a4afdb4ff34bce87d9792c9beb71bdb2464ecb62659cb73"
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
