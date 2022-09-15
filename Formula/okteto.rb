class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.7.0.tar.gz"
  sha256 "9dc31269f050fdaa93c3056ef037b37f7f2782cdd872b7fbc4ca8344bd260329"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06e6239374996e0249f1b4a92e5075436bdb9af44e5145d21dc45393b232d466"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e42f54b2e724e86750213f6da4f15174c795cdba8f55c5431a1d3aa8e52fac2f"
    sha256 cellar: :any_skip_relocation, monterey:       "9e1b93b9047ab0a0b4fe297f58babbb0388e7dd752f59eb7ca615255f4778592"
    sha256 cellar: :any_skip_relocation, big_sur:        "0321ba51e6a4b6db23d524ae7ae4d9850307c9351ca9b832ce972d5ca995d62d"
    sha256 cellar: :any_skip_relocation, catalina:       "413f48ad52f093515d28d8e3acf605d4fd7ce24e4b59dbb576da9e870a992b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "128c701e90ba2ab0859d552894cdaaba508d8e4c97d67345d3d7abda35d87304"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "No contexts are available.",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
