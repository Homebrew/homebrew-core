class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.5.1.tar.gz"
  sha256 "dcd5b5cf85cc37ecd30fe7bf706463192210cbbc724a4399c9dd9713d45c9c06"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3dd12a7b9336ad42fc5bfebbeea3077893c035ea0584bae03145d2d714bb3e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f104e6b68725f0d77fdda72f95db51f8ace94876c296e545945c5d2593b034d"
    sha256 cellar: :any_skip_relocation, monterey:       "13c882e86517d6b386ccb56a6e9bdcc5da0dd00452ceca03390ee804316f993f"
    sha256 cellar: :any_skip_relocation, big_sur:        "68def10016601386f337520dd3d4c70618ae82bac6cec0f9ae55edb7ea11cb6d"
    sha256 cellar: :any_skip_relocation, catalina:       "6707d113422d66965d75ca751facf951e02014cb7f206602c7375611d54dcfee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b8ba6685ab9a3cc84ffff3bfb953975067e8a260749b2c954bf7d164f634c13"
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
