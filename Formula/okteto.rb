class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.1.0.tar.gz"
  sha256 "f704a3c92c84023ba2bb28d0cd7934a1ddc045faad9a5c2eb3ae7222f3e67eaa"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39d7cac1987017162c26fa63700f1cbef8f3dceca8d5ed86324f549000a5044d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3608177e9195004280a0beaf85f8ddd707f8ac65f2beab0dfa565f5aedbba53d"
    sha256 cellar: :any_skip_relocation, monterey:       "f03aefa51f699b695a7e96d6e50bed093bd71bde4f34727174097550b72fd2b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0a733683128b324f695cb8af51d295fd119d7cd08a93c56a56c2538ce7925dd"
    sha256 cellar: :any_skip_relocation, catalina:       "f1a622405faf80f894b7a0570e0d5fffd6d9e4288f3548689b22296280b2e732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05c50ae930d2361fa0094db42f1a1432b3bb0cb1695ef29635db5619fb26571c"
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
