class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.13.6.tar.gz"
  sha256 "c88629c3cdd91b31180fbce14e0c1066bafb6786171b48925672db1c5031ebc3"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6e76af1bfc9859e47bc872e849c074b509d36dead7b51714b6b5df65b1b17cb6"
    sha256 cellar: :any_skip_relocation, big_sur:       "2b201428942bc71974e9e8883a590344c83b996990d84d11ed8c741b5d6fc935"
    sha256 cellar: :any_skip_relocation, catalina:      "8d7ec53c4a8081231e901d315030cd667dc06de4d542158cbc01becec8a765ed"
    sha256 cellar: :any_skip_relocation, mojave:        "b0ea028afb99c07d1a7048a49b64d846f7ae73fa68707d0f23436da217d43d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d780d0a220abb2ab9eee10def25c7ba55bee7088e99d40b579825ac1bc1b535"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    touch "test.rb"
    assert_match "Failed to load your local Kubeconfig",
      shell_output("echo | #{bin}/okteto init --overwrite --file test.yml 2>&1")
  end
end
