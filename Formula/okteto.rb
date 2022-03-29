class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.0.2.tar.gz"
  sha256 "122570ea7774d7808ddfd600f2208af6880b0326332dec02f4ed6d36fb626008"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a7e28e9350d491ebceb10562eaa1da75a9c15156976c3094ec54bcc9b558160"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "310b61f3034beab56de4e88ff46e0413a58dcf468ca8eb7adac5a41c6ddc3d53"
    sha256 cellar: :any_skip_relocation, monterey:       "789581dff2fac106417033283bbd1d9b46dd0247242a0c5884fd906e91d2b1e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddcaeb876f4ee9f2268ae7d2266d7799c0c8e9bb0d3dd70971c1a1afc8bc3ab7"
    sha256 cellar: :any_skip_relocation, catalina:       "c9bff12d221e68d8713f2c811bed621420ba1fb98ac294a2c6ba79d23915c27d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8114a22416a11a69a4bba26442691ca4984b23fc8c7e0dd16d92b08e29608bbf"
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
