class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.3.2.tar.gz"
  sha256 "36b9f91d42ad082b1280421c0fa137f4ff6afc7a99ab646d92e73beb29c8881f"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e4d4a859dfd9eb0840c1df4a31188ccd68fcfbcd8b1fb3dbf28611d5bc69312"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47ed876fc8d414c2ed167673dded1deced0b715ca031ea9bd92e878ababa7906"
    sha256 cellar: :any_skip_relocation, monterey:       "7046c429873cb09900b05b124dca338907954c02f3c26af7615fb06c10ca0c84"
    sha256 cellar: :any_skip_relocation, big_sur:        "33082cf29b611dbe0d611fa0e831ee002b90ffbf179231fd003eedaee8ae82a4"
    sha256 cellar: :any_skip_relocation, catalina:       "028d22f15ee26015b8ef8e8add9d04135f4fbb1178de961299a1ffd48950473e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d71ed9c000012077bac29bd31fdfce76dc53a7c032d5df72c7a7744dc5836a2"
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
