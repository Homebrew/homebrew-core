class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.9.4.tar.gz"
  sha256 "9c490eaa5dd509581e7c272d6af22b17c22b2915267e242ce927f17850ff4a59"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ef632ca52587510de84aa0cacbde3b175419f65453117601eeeca1acf0a54e73"
    sha256 cellar: :any_skip_relocation, big_sur:       "d4f6b798059264dd3c2a3436a507f62a511104e41fd54755f17ecc03fe5b38d6"
    sha256 cellar: :any_skip_relocation, catalina:      "1c084c687d02f76d076031b6bdecdb47bd84eb7cc143cbae2922fc67011a8d1f"
    sha256 cellar: :any_skip_relocation, mojave:        "7783607cf39d781c8817d27ecfbc0653c3a8653d82307842f2d0586f520d2b07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "529950d9c488a4f154d3995cd2e03cdef7e61089267ff0cf8c0661131b698c46"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=#{version}")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=#{version}", output
  end
end
