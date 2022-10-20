class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.6.27",
      revision: "eab653d7fd99146a1f72df1ddaebd64e90b24046"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb31156e3bbad3c20931fad183fb3904ef7a21c6c1d176ffc6d18f15356b9b36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f8cfe3b9fc90e8ce11bdc693d6a17c7303cbe5e5585b1ed6317dc2ddf64d5c4"
    sha256 cellar: :any_skip_relocation, monterey:       "3bf5474c084c972f8e03bddf59991fabedb5837f8104a931a404f7ee581bbb77"
    sha256 cellar: :any_skip_relocation, big_sur:        "e73296c0d35d9d4d01313a9967bc9a838f4da4b890ed25c50b69c7893b582f12"
    sha256 cellar: :any_skip_relocation, catalina:       "abbc89315e7fca3132d727d88fc1e3d5659c2d808d861879625e0b2f51a20e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26b0b7e9d5092ad0c1934bcaead536a40ba13bdcf1ef3366423696bfac8d080b"
  end

  depends_on "go" => :build

  def install
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
