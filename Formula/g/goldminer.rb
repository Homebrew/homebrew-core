class Goldminer < Formula
  desc "A terminal-based Gold Miner game"
  homepage "https://github.com/kongtaoxing/goldminer"
  url "https://github.com/kongtaoxing/goldminer/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "af7c4435d557b9a8431fb03daaf8928831ff97b70d12ef1293f13437381baff8"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/goldminer"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # This is difficult to test because:
    # - There are no command line switches that make the process exit
    # - The output is a constant stream of terminal control codes
    # - Testing only if the binary exists can still result in failure

    # The test process is as follows:
    # - Spawn the process capturing stdout and the pid
    # - Kill the process after there is some output
    # - Ensure the start of the output matches what is expected

    require "pty"
    ENV["TERM"] = "xterm"
    PTY.spawn(bin/"goldminer") do |stdout, stdin, _pid|
      sleep 5
      stdin.write "q"
      output = begin
        stdout.gets
      rescue Errno::EIO
        nil
      end
      assert_match "\e[?10", output[0..4]
    end
  end
end