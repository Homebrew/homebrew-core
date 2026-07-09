class MacCleanupGo < Formula
  desc "TUI macOS cleaner that scans caches/logs and lets you select what to delete"
  homepage "https://github.com/2ykwang/mac-cleanup-go"
  url "https://github.com/2ykwang/mac-cleanup-go/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "7a7186689d35f22d928d0cf4c63f86e89531e91520071d5cf1df7176c221b3f2"
  license "MIT"
  head "https://github.com/2ykwang/mac-cleanup-go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df851c49c1ff9be55279f47fe69165d1904a5f7556adb69ab0cbb434f19a8fbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df851c49c1ff9be55279f47fe69165d1904a5f7556adb69ab0cbb434f19a8fbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df851c49c1ff9be55279f47fe69165d1904a5f7556adb69ab0cbb434f19a8fbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "84f66ef173d692b9a07e5ae3f5befe7d75c64e0b7868c68563e268bce300090c"
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
