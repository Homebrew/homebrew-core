class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.11.0.tar.gz"
  sha256 "96eabb45d12fbb85f3a90169962179ea7919b861d54b00e7ab51684735ef4cac"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8e0e872a5a776556e600a4cb27ac59aabed43b8ada5ced9b7ca9c54be2de6a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cef8c092e3c83d7d7b8b5b329e3ca5025b54094f1bebffdc234984f96dc8dfa2"
    sha256 cellar: :any_skip_relocation, monterey:       "cdf93508817e4310894f900dfc44e5c047a65e9b03e49ca5bba9095d320cb2ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccd573a3c34a20d3707e90e1453a805e1f5c7affabaf0bf708f2ffd2475c5db2"
    sha256 cellar: :any_skip_relocation, catalina:       "e7d1f508f23ee464e2a30583a740eddf3cb929c8c9aaad2df13e3e31b9721037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7df3bdb1ebf367fd4e2d08e18e3ed251ea5af839cc8080a50bd20a28b2ea3c34"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=v#{version}")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=v#{version}", output
  end
end
