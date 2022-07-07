class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.4.2.tar.gz"
  sha256 "554edb747ee39a145cf29c9c750ac1edc30561a08ce8420f632890dc7fdbb7b6"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebe5ba56150f4de2301ef8fc1326556437dcf814b8c28d268d2e2482d0e74090"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bdbd98f97b8b257e97f691ce4171ca430b7c8313a15bb92777eed028ca55c4d"
    sha256 cellar: :any_skip_relocation, monterey:       "43c973188664b155bd14edff829af5e0ac350f80799b035db9285caf187e189f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d51f9100ba59f5ac99cb3c6d9f52b1d47e3a639d0e63a6802f7f9db54a41418"
    sha256 cellar: :any_skip_relocation, catalina:       "690a23292cef503978d7131566222541c07d6d84e2eb9eadcf3044ec209fa8a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4692a68c579f6d9bd875d75f7346724cca79e0fdff4b11f1c0dc81204eefabe"
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
