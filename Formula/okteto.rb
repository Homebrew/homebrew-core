class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.13.0.tar.gz"
  sha256 "5ffbe8bf4f872038bc813264902cc845a68b7c0771ff376c4186b69c554cac48"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "307a101f439cb3ae51305c5457240137d3b68293f89d593355250f9cb5f063d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11dfe9c640fb43aee12bc0734ada996350ab1a20ca95d64f813f56532de7fa4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f112c52e2015772a15a54fd5339e11495f821479e929235f81a9acf466cc892c"
    sha256 cellar: :any_skip_relocation, ventura:        "d800ffeb0eb76d54e0757add5ce48c7a1c00a90a2eb1cb8551c15b8b35605d1c"
    sha256 cellar: :any_skip_relocation, monterey:       "b6fb1d5705293c4b7535f6c80954882bbcd63138c9511efdbefeee16ca79a5a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "bac8cded1b025366ea080e542bb5ca4db0e28538d19b027c245b7d1fbd928642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f6004f37e44a4d98034739308e8cd0dc51e195f8ad1c9bafb7f8eaccaf6faf3"
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
