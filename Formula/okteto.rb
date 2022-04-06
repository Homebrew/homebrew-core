class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.1.0.tar.gz"
  sha256 "f704a3c92c84023ba2bb28d0cd7934a1ddc045faad9a5c2eb3ae7222f3e67eaa"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be4ec65bd385396eab1d3259e155cf86850e079ae5fde4bfa3401af34a56ac3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d2021f96d83c967c8282305117b3f490c94881e5da892b23b199e799f078002"
    sha256 cellar: :any_skip_relocation, monterey:       "678f29861cae2461231096786a823558ab28ef23882940cde0d4f1dc9d2c9fdc"
    sha256 cellar: :any_skip_relocation, big_sur:        "23be1a07c503372cfe7f388028e337d02e6427451826020c0bac17db7e18682c"
    sha256 cellar: :any_skip_relocation, catalina:       "dd7ed9b664843c6b27c8167a72dc7a6f961f7de2cf9b0a139998e6b09613d8df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59a31cb0e8f999c0188b487e753bc0ae721ac4c83aa2a4d5c8a9c2c72370fd7e"
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
