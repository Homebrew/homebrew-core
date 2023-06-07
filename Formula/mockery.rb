class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.28.2.tar.gz"
  sha256 "045a76a037082412dd3900ebd9ca340ea71ac57c175c5bfb39ee20d62bf087d5"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c13eeb43956f715c1fb4c42fd9dbc07e4cef9bcdee521c76f70653a7b53f9f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50af1b96114ab48b720feff4fe40b6f71b8848da34363c56c927dd2e5cc62ea2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6de29ed50442e81f410443ace4285c6c4bbd2fc059fe063ae1ef0c743a988958"
    sha256 cellar: :any_skip_relocation, ventura:        "ffd7a4ef02afbd837ff388d0b2273778d409afff40825183cc2b1de4ce8e993e"
    sha256 cellar: :any_skip_relocation, monterey:       "6be02fce30b1409b7f2f64349eb3bb88539f6c4f6bb77a4d78c7141d204f01a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b7f62225bbede3c853a335bee55794918157a208939097613bb5a4e6ce0fcce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "633e5fe0565bc8f653d324e7a33a1a216c75752d963b959246644f6880384569"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
