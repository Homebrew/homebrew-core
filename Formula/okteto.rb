class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.12.4.tar.gz"
  sha256 "73f3201442eb6d04ace55122c2478b815def7a616576b7f570e557b2f5e1fad8"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "29bf34590bc52f6f73cdd1751949c566dae2860cd7d65f19cd3a82d50927c688"
    sha256 cellar: :any_skip_relocation, big_sur:       "2c72f49d3695aa675eddc5c679b89d358ac3fda76f4a8051d4c4b68d3167e435"
    sha256 cellar: :any_skip_relocation, catalina:      "a981d404777be76d968c918f3f7d88390dfcf4fad368548499e9bd3002c7c6f4"
    sha256 cellar: :any_skip_relocation, mojave:        "1c5dffd24a84ce31b404027d4421ba07f560ccc836d032edcc24dc1a7baf5ec1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    touch "test.rb"
    assert_match "Failed to load your local Kubeconfig",
      shell_output("echo | #{bin}/okteto init --overwrite --file test.yml 2>&1")
  end
end
