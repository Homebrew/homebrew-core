class CratesTui < Formula
  desc "TUI for exploring crates.io using Ratatui"
  homepage "https://github.com/ratatui/crates-tui"
  url "https://github.com/ratatui/crates-tui/archive/refs/tags/v0.1.25.tar.gz"
  sha256 "b02e2fa3b7225b5638f9ab8716c3cf21dfb32d96aee140ead2f451005abd58c2"
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
    # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4.
    # Using `cargo update` rather than patch to work with stable and head.
    if build.stable?
      openssl_sys_version = File.read("Cargo.lock")[/name = "openssl-sys"\nversion = "(\d+(?:\.\d+)+)/i, 1]
      odie "Remove `cargo update` workaround!" if Version.new("0.9.114") <= openssl_sys_version
    end
    system "cargo", "update", "openssl-sys", "--precise", "0.9.114"
    system "cargo", "update", "openssl", "--precise", "0.10.78"

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
