class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.15.6.tar.gz"
  sha256 "af288211a255560a6dc1003287b50006df69ec119399029c4fe52adeb21e1569"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "632bb235e192b3ab9d8db33266e499155f5a19c3e787b781f997072279399906"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "738caad3724f11d19b75b7af26dddc216596885751305921287f330a5c3d9294"
    sha256 cellar: :any_skip_relocation, monterey:       "ddf2842edb5c4a7c171ba68eea525107b4cab793b2801214c428fc6ed16643e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "866125e169ede683a92c10c28d0d1dfd70c523b496beb9510657a9adcba92138"
    sha256 cellar: :any_skip_relocation, catalina:       "985632f85c02678df6b74126215b912b8579e16a6329b46602ed8ae9988a727c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46f4ba33c984ecee8c6882c60ee023d04ba57e1c8e4879f63d06cdf064e1cac1"
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
