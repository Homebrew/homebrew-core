class Nfd2nfc < Formula
  desc "Convert filesystem entry names from NFD to NFC for cross-platform compatibility"
  homepage "https://github.com/elgar328/nfd2nfc"
  url "https://github.com/elgar328/nfd2nfc/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "ea53755802bbd85aa52e4d56d251c20bbf490bce39c28551852b2f7f02e042cf"
  license "MIT"
  head "https://github.com/elgar328/nfd2nfc.git", branch: "main"

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "nfd2nfc")
    system "cargo", "install", *std_cargo_args(path: "nfd2nfc-watcher")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nfd2nfc --version")
    assert_match version.to_s, shell_output("#{bin}/nfd2nfc-watcher --version")

    require "pty"
    begin
      r, w, pid = PTY.spawn(bin/"nfd2nfc")
      r.winsize = [24, 80]
      sleep 2
      w.write "q"
      sleep 1
    rescue Errno::EIO
      # Apple Silicon raises EIO
    ensure
      Process.kill("TERM", pid) if pid
    end
  end
end
