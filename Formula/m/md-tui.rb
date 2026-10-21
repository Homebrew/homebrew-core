class MdTui < Formula
  desc "Markdown renderer in the terminal written in rust"
  homepage "https://github.com/henriklovhaug/md-tui"
  url "https://github.com/henriklovhaug/md-tui/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "b86f03f536235e3016a0f5287ee86972e9a92293586b1c426d0e067b0dd3c0b2"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "22b8a3a46d48d04dc23fa4a55a5ba07d1369aa0c5cd0b0c79986abc3b98cb6a0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "017f6c2cd6928fe96ba0288305a817d7f80e14b6ee04f3192620008ae4d5819d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "435b4c4234e63aa74a9fb5ff6f25d948db1f207b8de03c61b9fb4dea6338b02a"
    sha256 cellar: :any,                 arm64_linux:       "528e4e495d8dcd425ea89c12abd5c921355f3f33d4c36576d56c044f5db595c2"
    sha256 cellar: :any,                 x86_64_linux:      "629d49ea86917685617d498eca423a47c482753144baf88b79863258eb6e7aa9"
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
