class MacCleanupGo < Formula
  desc "TUI macOS cleaner that scans caches/logs and lets you select what to delete"
  homepage "https://github.com/2ykwang/mac-cleanup-go"
  url "https://github.com/2ykwang/mac-cleanup-go/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "a8a6e9036a46a60494c4ff884e1c89876834b36f184f01b6febda8c32dd2f324"
  license "MIT"
  head "https://github.com/2ykwang/mac-cleanup-go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08329a1b1084fcbafea0c459780b75e2024c5385978ddb2eeffe34f48b0dd765"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08329a1b1084fcbafea0c459780b75e2024c5385978ddb2eeffe34f48b0dd765"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08329a1b1084fcbafea0c459780b75e2024c5385978ddb2eeffe34f48b0dd765"
    sha256 cellar: :any_skip_relocation, sonoma:        "392157dbb8138020888d89d8ef0763084e1f1dc33cb089e3e713fc68c2148450"
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
