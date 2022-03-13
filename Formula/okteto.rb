class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.15.7.tar.gz"
  sha256 "66582870c6746e83b0944c3d98082c6a86b4c414d94c704b54cb7797cf94504f"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "326ee74b2e5fbf6c080facc2156d56352b7f5b5eaa4dce0c2fc7851f256632e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb21f61cd2f364223811189056ad8524bfdcfb23d8505ef011dd3123b8dc8f08"
    sha256 cellar: :any_skip_relocation, monterey:       "82d2ebd62859dc57da1f4dbd6162c6370044066031f124573f5923c164638f59"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a9d12e041ddcc3a98b6a30f738613d6316f8ef698f657aabd1bd3b639034fdf"
    sha256 cellar: :any_skip_relocation, catalina:       "c0a4163040c91cb9c72dffd8602e7c934d3147729ac5cc75b6a3a871513a22dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6b524d64529dc9f853df6b8aa3b45770f2371f31ba1a9d7dd6109df9e53af26"
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
