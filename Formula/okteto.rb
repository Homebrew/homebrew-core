class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.13.3.tar.gz"
  sha256 "53441cede140f3c543e6fd30de6ad8b5bbd9547e38cffd9892e31db6aa188f40"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4261b52be9e1c680f94fc963d69f6bde661b017f18ed4f74632fb9f456ee7c4a"
    sha256 cellar: :any_skip_relocation, big_sur:       "49f9c40de6b0cf52fc4b4e718299a3407da1382c75a68b4c469e4cb681af12ff"
    sha256 cellar: :any_skip_relocation, catalina:      "a40a6ca85db08b70a21feab9ab3d6d44670a3589c745411d3eb2e55223502d0a"
    sha256 cellar: :any_skip_relocation, mojave:        "6a52b050b62960d16e83905a6126aaed33d1157eb0a84fd13790da51683f9bae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4da70a04ddf17ac7f37641d84b62bdffaf9fe0f60a73b478f301c3acbc1daaa8"
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
