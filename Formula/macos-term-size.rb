class MacosTermSize < Formula
  desc "Get the terminal window size on macOS"
  homepage "https://github.com/sindresorhus/macos-term-size"
  url "https://github.com/sindresorhus/macos-term-size/archive/v1.0.0.tar.gz"
  sha256 "5ec39d49a461e4495f20660609276b0630ef245bf8eb80c8447c090a5fefda3c"
  license "MIT"
  head "https://github.com/sindresorhus/macos-term-size.git", branch: "main"

  depends_on :macos

  def install
    # https://github.com/sindresorhus/macos-term-size/blob/main/build#L6
    system ENV.cc, "-std=c99", "term-size.c", "-o", "term-size"
    bin.install "term-size"
  end

  test do
    require "pty"
    out, = PTY.spawn(bin/"term-size")
    assert_match(/\d+\s+\d+/, out.read.chomp)
  end
end
