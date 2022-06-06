class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.3.3.tar.gz"
  sha256 "6c989e9428db55d42b71dd3cb4359f3aca174fd55cf04964c5e15e32bc3162e5"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb8ba878a21aa7d11c95038488049a6abea460b367046cd1c40cf3392a61c861"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11e0fd1e80cdd767b465ad01d16781673ea57ecf6bd9a6caa341bc37eea1812a"
    sha256 cellar: :any_skip_relocation, monterey:       "45d371962143b780916400edfe314d9969267d472c2fbdaf69a2fe169fd983d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "d17a295140193bb2c0e463e4a1998dbcf0c426239182c9d202b58d3e70320430"
    sha256 cellar: :any_skip_relocation, catalina:       "73a25462c2f2bbdcf591da2853a50cb04f66ca2030a3220f81152518c1d0936f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "121ddc254aa3cc485572917c3020b2128e88302282222eadc467155c385c87eb"
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
