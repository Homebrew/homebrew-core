class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.6.20",
      revision: "ad869c06c884b10f88948b5852ab22b4d7262e20"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89f81c96934e3f74135944309fb3aa3a27bd2ec79eeab359671a3b7f80f03341"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c161e349f898177e02e93af40067facb43ca6e398860b206c46d0417bb3e86ab"
    sha256 cellar: :any_skip_relocation, monterey:       "24852e3402e983192cbf42ea4d5a4ac2018c6503a961204b318dfcbd651d7705"
    sha256 cellar: :any_skip_relocation, big_sur:        "ead108d62d0eec9b22c54ed9f360bb93d84eedde0a359924280d9dbed330c975"
    sha256 cellar: :any_skip_relocation, catalina:       "588f4adf2f512877e377e2239ed4ca639a0a8ca99bbe450a722a3a9f71c98013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef6484f116d07b81e19407479496a64079d95a4d97311817e48deb1a25f40bb1"
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

    bash_output = Utils.safe_popen_read("#{bin}/earthly", "bootstrap", "--source", "bash")
    (bash_completion/"earthly").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/earthly", "bootstrap", "--source", "zsh")
    (zsh_completion/"_earthly").write zsh_output
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
