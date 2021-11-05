class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.14.5.tar.gz"
  sha256 "279eb076288ff0bf60a66b9c3ea4bfb43c1dfb4585f6cc35bec975ab0b67e90b"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90b2f86e5f0abdca3b9773df459019765c31496ae1f49e3056229bb023d450f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c465ef5a7b112f7ebc468e7bac27d5f50e4e55d0ba9c93bf03836d50dfdb5b4e"
    sha256 cellar: :any_skip_relocation, monterey:       "5a7b11107e22d26718b94f727f309be5949ff1fba139b454210551e86b7dfa3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a76dceed679920d9b085aaf0b50b992b14890e506d8346c86aad7c8b4f5d4211"
    sha256 cellar: :any_skip_relocation, catalina:       "3e7906a90b9bdc7a3bfa3e1ca0f4a3036afe712a9ab302bbb130c6313070dca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c161fdc565041ece4fd528d82a7e8cf2b08f216b49f216ff869ed50458688906"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "No contexts are available.",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
