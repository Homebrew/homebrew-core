class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.3.3.tar.gz"
  sha256 "6c989e9428db55d42b71dd3cb4359f3aca174fd55cf04964c5e15e32bc3162e5"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c587cf4876fbe34d6abd654f31a866741d08ea633a37ef556906431e834e6bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9577c7cd8ef9d3b4234f1754ea0db5d4de9e8ece4ec1791d1322935951ba8f13"
    sha256 cellar: :any_skip_relocation, monterey:       "3ad845efe546b1d4363ec5fd2493b553ee147862a08546f3e0c1786fc8eec34d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ae12dc52b26e6b43f7e708d8d93ec43f4b67d170df265229738eecdffd3df95"
    sha256 cellar: :any_skip_relocation, catalina:       "56ea865acf4e783fd892e024dcc9bddc9ed220a2161fc9bc9419540b48a788e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59df823ec70a0d884ea7c7e4b7e04f3decbbd3a263f7d0e214778ded1a4ffac9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    bash_output = Utils.safe_popen_read(bin/"okteto", "completion", "bash")
    (bash_completion/"okteto").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"okteto", "completion", "zsh")
    (zsh_completion/"_okteto").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"okteto", "completion", "fish")
    (fish_completion/"okteto.fish").write fish_output
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "No contexts are available.",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
