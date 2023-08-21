class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.19.0.tar.gz"
  sha256 "11dc934754b92cebbf63cbc57267c80e2cb68b065d1eedd2a1d07586d466a39b"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ae6c9ee655f74b771ea9226d70cfd83a151c05bd9b4da478c133cd14ce9a572"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a34ef3a488ba0707a440afcc1ff0fb010e968f23d9ac0128dffbdc29aa6278a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87e49761efee9f3d961bb05974344e96d171c44bd6b26a52eb3d33be44eb8126"
    sha256 cellar: :any_skip_relocation, ventura:        "35cca79d86b783418c7fa45a6fc8f5efe546127f18b53ffe666d7a4a0ffcdada"
    sha256 cellar: :any_skip_relocation, monterey:       "34341ff69a97156a3c28f2d4e40d259bd6a16e171871b57aabf406259d2fb617"
    sha256 cellar: :any_skip_relocation, big_sur:        "d36adcb5ca25b4b42368f95697af93a5c8bbb3bc0fec44b61e4e6f2f82a122f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02fc16a44ab59abd22169b3199af78ae8730406bf7a41865f1e275f4b0554ce4"
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
