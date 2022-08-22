class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.6.0.tar.gz"
  sha256 "5cbd2e620741212c5588605a305f7180e79534238d8b934d073c32b2ae96a1bb"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eea04a7db75891abf59d76a1dd5b57ec1dfecfb8e09b20085ba9b688372257b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae70948a0813b67d039c497e4c821fad61610a4413cdae0d4a4ac0ee30485889"
    sha256 cellar: :any_skip_relocation, monterey:       "aca32c7257439c558822da95668ced58c316c96c0ef567feddd872521af70de5"
    sha256 cellar: :any_skip_relocation, big_sur:        "72102848b40f821ffdabda20327521451b173090b16181128d85a9a9d5eaaebe"
    sha256 cellar: :any_skip_relocation, catalina:       "e273c1a2b88290f2f77f8a57d21fb9ef88799b3333de631072deedc270ba74a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7ed25c61d795e368adc36edc400d2c187906b5dfbc678174e7796eb8a445492"
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
