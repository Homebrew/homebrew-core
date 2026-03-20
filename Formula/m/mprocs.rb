class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https://github.com/pvolok/mprocs"
  url "https://github.com/pvolok/mprocs/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "fda5d8db13540459ea1ed65524f50c6492f12e0f627cde522164c17d6d7b9ecb"
  license "MIT"
  head "https://github.com/pvolok/mprocs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d45b2716d7fb2708536e493de2a367b1ab3a423b86f61442686d78c724217b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3ee720c9c2533f27625b4e21292db06c6339d0171a9ff96fdae72ebcd1b391d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbb5be5492c8e2e82e8f723bb347cdeeb8919b17a83ac68e63d3a8f096c96d11"
    sha256 cellar: :any_skip_relocation, sonoma:        "21b1a7f42cae30afff754ca60c4bec9dbc2cd232394c5e53718de9b4185dc518"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84f1369eb99521b6f5b4f1a39c8d5201135d8efd4c3b0be5f7d0638869cd4cce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e01b1d40bf2fd617fe5c879e632c10228fdeab80007f7c86c6dd26b92048af7"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build # required by the xcb crate

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "src")
  end

  test do
    require "pty"

    begin
      r, w, pid = PTY.spawn("#{bin}/mprocs 'echo hello mprocs'")
      r.winsize = [80, 30]
      sleep 1
      w.write "q"
      assert_match "hello mprocs", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
