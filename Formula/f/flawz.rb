class Flawz < Formula
  desc "Terminal UI for browsing security vulnerabilities (CVEs)"
  homepage "https://github.com/orhun/flawz"
  url "https://github.com/orhun/flawz/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "641264999d2a5d662bc3d9c3994fcc580b92a2e9051c79fbcb8fdb2220924f30"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/orhun/flawz.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7701200ca9a319e1630bdd0ae229fdf4cfe2ec8c0f630e29cfb997f22b0a651c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a5391e6b06f900858eae6f6b6b56daf0d488c6c839adb184164b777be4d6502e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5bb8302663275870e215fca1308fe23cf7caa0d6eefa1e21073f3bf3d43fd503"
    sha256 cellar: :any,                 arm64_linux:       "ec4de4d6a20c29e7ad4b9ee64208293b195cd91831cd88e22e071ea7bdeac971"
    sha256 cellar: :any,                 x86_64_linux:      "3b9066f11b2a40a1cf9e3c90e734cd5403da68e085afb096c5a7b1f6a5c3a44b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    # Setup buildpath for completions and manpage generation
    ENV["OUT_DIR"] = buildpath

    system bin/"flawz-completions"
    bash_completion.install "flawz.bash" => "flawz"
    fish_completion.install "flawz.fish"
    zsh_completion.install "_flawz"

    system bin/"flawz-mangen"
    man1.install "flawz.1"

    # no need to ship `flawz-completions` and `flawz-mangen` binaries
    rm [bin/"flawz-completions", bin/"flawz-mangen"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flawz --version")

    require "pty"
    output_log = testpath/"output.log"
    pid = PTY.spawn(bin/"flawz", [:out, :err] => output_log.to_s).last
    sleep 2
    assert_match "Syncing CVE Data", output_log.read
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
