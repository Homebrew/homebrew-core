class CratesTui < Formula
  desc "TUI for exploring crates.io using Ratatui"
  homepage "https://github.com/ratatui/crates-tui"
  url "https://github.com/ratatui/crates-tui/archive/refs/tags/v0.1.26.tar.gz"
  sha256 "ea2a844f1e9a2ece95c3a09ad165c18529847b48141cf1a52a18eb9191ea8f45"
  license "MIT"
  head "https://github.com/ratatui/crates-tui.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cbd1a1f8537eb591f8f342c2ce626daa5555816402e248c919c93dbb791cb6ad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ea21f3ebf847d27e811afe469a9dea2c86959e933bbdffb5df13e53e567d355d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "491e8b2eb972a5fb67d3954990109f15d87b5968a9499a66626fb633ced28ca0"
    sha256 cellar: :any,                 arm64_linux:       "75ba336719871af965cadd8311a617a5ef41fdcee014c62f2558e61ceac40bff"
    sha256 cellar: :any,                 x86_64_linux:      "743c60883fcbc3c7cd1506852d63be4295a65852fb0f36c21e56adb858c2db66"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crates-tui --version")

    begin
      output_log = testpath/"output.log"
      if OS.mac?
        pid = spawn bin/"crates-tui", [:out, :err] => output_log.to_s
      else
        require "pty"
        r, _w, pid = PTY.spawn(bin/"crates-tui", [:out, :err] => output_log.to_s)
        r.winsize = [80, 43]
      end
      sleep 2
      assert_match "New Crates", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
