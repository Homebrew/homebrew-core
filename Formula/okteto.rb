class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.5.0.tar.gz"
  sha256 "e00ed96ee3b42ea375e7a69b4a9be17bf7cc0a682007e39cd4363771e9dc694b"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e568b8f8806a2da2e2c988891a09a09545e3c5de5911186363c1c9b3830e815"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48dd79a77c685b0270bf5cb7b98b178586f92a8bb97d35929439da7f3df64be2"
    sha256 cellar: :any_skip_relocation, monterey:       "460e06119e7dcb035201542274e23384eaf99cd6b8e3b0d84ca8f7b28574f18b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b33a81169937a905dd0e3c3507b71611d1a16a6ebdd8bb4da26017885addcd05"
    sha256 cellar: :any_skip_relocation, catalina:       "d2fc130005d189f3d7614646d913ca8ddc275a9cf9e88c744625f74af857c0b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04b816e99b780cef98a872f794dae6bd88440a391a025f029e5ab66c199a384e"
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
