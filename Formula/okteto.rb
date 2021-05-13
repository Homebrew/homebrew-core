class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.12.11.tar.gz"
  sha256 "4f6d8695b9cd39fb8c3e8cf96f73f588ae57ee0b0914331e5ac247a8dcf5a7ea"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ca5b18ee81fd1f7712323af1b53caefb122963ea74c0b7fcf0ca5d9296f85c67"
    sha256 cellar: :any_skip_relocation, big_sur:       "8d68f9be7ac86f701c2e9e0b593148b69a5d74d33e39c38eff93f31c4781a14c"
    sha256 cellar: :any_skip_relocation, catalina:      "adef7309e00fb500eb507826576ae4fa9b5cbf2dfc7d119952f3fa92ef49eb88"
    sha256 cellar: :any_skip_relocation, mojave:        "e31f89708fe7390eb0f043b0f588de8c7ce498fadfbc563d99a8407e2c3fb27a"
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
