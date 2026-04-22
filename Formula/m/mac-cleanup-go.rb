class MacCleanupGo < Formula
  desc "TUI macOS cleaner that scans caches/logs and lets you select what to delete"
  homepage "https://github.com/2ykwang/mac-cleanup-go"
  url "https://github.com/2ykwang/mac-cleanup-go/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "a67c5b57ff5904ec32257e3e2652dc9783133fa50cf7d63e87d1e68d79fd2fdd"
  license "MIT"
  head "https://github.com/2ykwang/mac-cleanup-go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb4d3b2c920380391acf597e5877726d0eaf8420f618efeb909ad9bc33f4932d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb4d3b2c920380391acf597e5877726d0eaf8420f618efeb909ad9bc33f4932d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb4d3b2c920380391acf597e5877726d0eaf8420f618efeb909ad9bc33f4932d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf634113a24084e37ce132c936abd4721917fac3f032e501b3778aede4131fc1"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"mac-cleanup")
  end

  test do
    # mac-cleanup-go is a TUI application
    assert_match version.to_s, shell_output("#{bin}/mac-cleanup --version")
  end
end
