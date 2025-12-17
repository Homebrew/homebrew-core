class Ccswitch < Formula
  desc "Command-line tool for managing Claude Code API profiles"
  homepage "https://github.com/huangdijia/ccswitch"
  url "https://github.com/huangdijia/ccswitch/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "dc035ee1de978240cdad7948e029a5470e2ebe1b8afa5d5bbf40387b0e373406"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/ccswitch"
  end

  test do
    version_output = shell_output("#{bin}/ccswitch --version 2>&1")
    assert_match "ccswitch version #{version}", version_output

    # Test help command
    help_output = shell_output("#{bin}/ccswitch --help 2>&1")
    assert_match "A command-line tool for managing", help_output
  end
end
