class MdTui < Formula
  desc "Markdown renderer in the terminal written in rust"
  homepage "https://github.com/henriklovhaug/md-tui"
  url "https://github.com/henriklovhaug/md-tui/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "64374823e6d3d8200063dff390088b5e7f3a5a6a3d4d19acf9bb5c29171ffff5"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e6417a5e0d0dea3f5abba25efef89532578143e368e23e8cf48e3db215fad25f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8ba0ea675bc87a1e9d226fde49a3f31ba913005b610ae335d0ba1cec08842207"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "65418b105f16e516dab80b928dcdf455142db734381bd500f6a8bfaa98fb04b0"
    sha256 cellar: :any,                 arm64_linux:       "d025315fd1ef46f17080423db0b260e574d6f9fad17f83bf260d05a356bf6d87"
    sha256 cellar: :any,                 x86_64_linux:      "4c5cf8470c42462846e31b4bc3cb08bed0877bd16a0bc0c12457102c74122454"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    (testpath/"test.md").write "# Hello World"
    PTY.spawn(bin/"mdt", testpath/"test.md") do |r, w, _pid|
      r.winsize = [80, 43]
      sleep 1
      w.write "q"
      assert_match "Hello World", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
