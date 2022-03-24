class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.0.1.tar.gz"
  sha256 "6f496072057cd823416c5358e50ffd93317eb0bd493512890f85c06b4d1765df"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afd06d12fa2c913fe526d4b196817d9a552afc60a93de7be888b1c594c502152"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d51c0482c1764482fc2e689b317645ffcbd5c1321512b3ab2121f1bff82e8e6"
    sha256 cellar: :any_skip_relocation, monterey:       "005edc3b2f8659a19007ea880e942decc321ffc99819173dc2c68cc0d21741b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "251a9322a4c6fdd7fca3d2f91cc2216e47d5ea9f61b556f7433ef1b89dc04411"
    sha256 cellar: :any_skip_relocation, catalina:       "ba94d1c1302c934d4aabf4ee2e7ef0aae0b38595ceeaba240a38c001e8a8b2e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cdeef3744b3c974aa497c7566d1c8514fd0e9b31adaad7bc8b8e145631033ad"
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
