class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.33.1.tar.gz"
  sha256 "ce2c179752930dd1754bc36e858ddb84d0f50c61ccb45fdce6c6d462aa34a608"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18ce14aacc51530da921e7a395bae6415a49ab576f43f453ab4ec178ebf84475"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c86d9ef2944f922898fd6c8284d60176cdce7ff46c520311b38fc4b21c716bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "152296123fcc46488d2aeaa0aa855402ba6688d1902925da6ac60e0f004ff971"
    sha256 cellar: :any_skip_relocation, ventura:        "4903d767cc4d26c277cce6b750567f63391bf1ece9debad4b26ca46f581f4391"
    sha256 cellar: :any_skip_relocation, monterey:       "7c7dedde3a776781dccc3f86454b86c33fd7127b48ce4b401ddc437fcadda44c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f179895e9f501d7476655ef8f5b86c42e03de2314c02401f630ef8414ee339a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f6234b75b88a212e32a52e01d142c9578f393aedcf7469b885e0b636d10b64c"
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
