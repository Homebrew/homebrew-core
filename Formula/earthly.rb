class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.6.24",
      revision: "20339818277375d1addc9cc20066a9890483761e"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b106f667f3755cf5e4bf4977fa0b9ef3016a5ae77e0f166ef33c884329d367a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20dfe3843924761dbfc1f841618e947d3b69f3b228c7fd098ff2d57e376eb779"
    sha256 cellar: :any_skip_relocation, monterey:       "7db4ff1187de889b6fea61ec1e7a9019a4257907f47b57541ed5c5c9307de274"
    sha256 cellar: :any_skip_relocation, big_sur:        "aac70c2a92eeb6b045ae4a8e6825cdeb76925a8f6e3c8a64122a591f3c72367c"
    sha256 cellar: :any_skip_relocation, catalina:       "51f358b38418cc44d956f92eae792688d1721deef9570c6f8163c41fdcd9c243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "625c79870a93f42a0c2f80914135d03404631ea45e740644a7d9401cfdf743a3"
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
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork"
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
