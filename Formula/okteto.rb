class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.8.0.tar.gz"
  sha256 "41c6273c7b8868e06bbf9d480d5b445b3e7c805c3cbf836fb930dd83de8be29d"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "379614f2c005c3e6e53b7215ddd2469a2d9b0efaf5adaacd452e5822cb26782c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "716677b7b03056e99bee046034e23959c9a677a5c71301b364e2f894232ec53d"
    sha256 cellar: :any_skip_relocation, monterey:       "a2c9d955a29205e306ae931914e5bbafd5363bae54b607ddc0762c3789ab7523"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1b2e4f841465ddb8e095eb03f8b872c6299072d2219fdde95dffb2d606af734"
    sha256 cellar: :any_skip_relocation, catalina:       "aceb33eb8e86371d9a97ed67cba067777418d96f2da4d7b355af5269ef1b9212"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d1ab10cd469ad74383b6a0c3444a29b1962976790ae37625a2d3c36b63717d5"
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

    assert_match "Your context is not set",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
