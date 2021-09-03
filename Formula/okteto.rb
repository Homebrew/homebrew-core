class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.13.8.tar.gz"
  sha256 "35391b9ba46e5c160927089349703bd35b4c1357aeee390cc9e59f00784203b1"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "24f5df1e158f4f224fa45afecd7fc89e5b4978d7eafd0bce641c14ae7e05e755"
    sha256 cellar: :any_skip_relocation, big_sur:       "e28e997c55af273b5f3c6a0849c86dec3a2d333c690619a6233c932881908550"
    sha256 cellar: :any_skip_relocation, catalina:      "0d0079dbfafb9590587ad27f2c370e842bbff15a010b6f4ffba7e50e1dbb7fdb"
    sha256 cellar: :any_skip_relocation, mojave:        "f2cb4e775cbc96b5a0bd5b24f6e1a5671490caeb9bce62e1630de565ed5702c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c82dcf72410c8a1b7b1b471f4285f3865f03ca661b2439d0062a9ee194b970e"
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
