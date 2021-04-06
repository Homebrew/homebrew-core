class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.12.5.tar.gz"
  sha256 "a17243341530ce06790337872617be6e51bf3fea04b9e57a161378eb56507415"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a26ef6fa3559457a34685e4154619de8e24812d22335c650e502b278d0af84fd"
    sha256 cellar: :any_skip_relocation, big_sur:       "6b7bfb9f77c8da043820672cca7ef5262d7dfa4ee63f89cd8eb9fd72d1ae9c8c"
    sha256 cellar: :any_skip_relocation, catalina:      "5c156c32073aefa2f86e7e2eac517aa22385c87cecbff4e739f717ee79672486"
    sha256 cellar: :any_skip_relocation, mojave:        "d78af63cb1b74695be6c13f0a05d778e846769a1f8f2703df317426598e90f86"
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
