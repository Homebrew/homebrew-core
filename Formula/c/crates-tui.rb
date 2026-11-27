class CratesTui < Formula
  desc "TUI for exploring crates.io using Ratatui"
  homepage "https://github.com/ratatui/crates-tui"
  url "https://github.com/ratatui/crates-tui/archive/refs/tags/v0.1.26.tar.gz"
  sha256 "ea2a844f1e9a2ece95c3a09ad165c18529847b48141cf1a52a18eb9191ea8f45"
  license "MIT"
  head "https://github.com/ratatui/crates-tui.git", branch: "main"

  bottle do
    manifest_sha256 "b998fee038f87d855d1b4659b2c300ebe9c0871fd6846d173132a28c0f9c543b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6c4fe3d18221bc32eb7e9fdd136a41bb4db15789603499bb4f3a8d8a4b4f794c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f1b8960f9f4e6ead02dba75c56a162252c40318857cb19fa6438270f05f6068f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8c01ae78ef4bdff275845cede73bc16bf08710a825979bc8083e6f4e4359d3d5"
    sha256 cellar: :any,                 arm64_linux:       "e480ee9d49693c0cfacc2e80e86228df14b23a3643d302137404b91322a3b4e4"
    sha256 cellar: :any,                 x86_64_linux:      "e8f8daad1d515181eda38ccd1c9270281c7d77810f2b5a5a5d0c5009a71569cb"
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
