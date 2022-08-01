class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.6.20",
      revision: "ad869c06c884b10f88948b5852ab22b4d7262e20"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17631724a77df509b204e6ecd7cbcdbfd295feac8302912f897110030e515b73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72f93115cee671ffd1baa2b61a6d395fb16f050d344da5597bc97d9004dbb450"
    sha256 cellar: :any_skip_relocation, monterey:       "50c27f452dd0e24f8429f19dc77396a4dd54fc9fe2aa638e55e3228da1faa85a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7abff5df8c9b1ea9d641650d91901f9efd551d53bbce78614f0ea75a5fc15f9"
    sha256 cellar: :any_skip_relocation, catalina:       "851f8fa9b8fc098348278ff64b57d476fb2e5c4320ce14955be1c934e5999a04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7d19864a6bb6c6a91061ddbcc63c38e4219b5f29f4a0e1c85478d0fbcadf536"
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
