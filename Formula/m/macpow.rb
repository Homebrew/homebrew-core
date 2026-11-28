class Macpow < Formula
  desc "Real-time power consumption monitor for Apple Silicon Macs"
  homepage "https://github.com/k06a/macpow"
  url "https://github.com/k06a/macpow/archive/refs/tags/v0.1.20.tar.gz"
  sha256 "63cbe257c52ebbedc8a2252e6f050055573cb7c87277528233cd309805d7adc9"
  license "MIT"
  head "https://github.com/k06a/macpow.git", branch: "main"

  bottle do
    manifest_sha256 "e0c4b6d77bed124054b705ebcf39372fc089d204e8faa726beb0276da6e44fd5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "695c53a338abf6fa3d00ee4464266088ef9a84735cefe3395d2c7d104a2af794"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "56d7ca0f96bbc0de2efad0b911174907fede1db1c280b3c62882f11df9251823"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e2832f75b5b9190ed33903b9deab84d06ddc2d6d9b96ddcc6e2eaf641bf9acba"
  end

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on :macos

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "expect"
    require "pty"

    assert_match version.to_s, shell_output("#{bin}/macpow --version")

    json = testpath/"macpow.json"
    with_test_process(bin/"macpow", "--json", out: json.to_s) do
      sleep 0.1 until json.exist? && json.read.include?("\n}\n")
    end
    dram_gb = Utils.safe_popen_read("sysctl", "-n", "hw.memsize").to_i / (1024 ** 3)
    assert_equal dram_gb, JSON.parse(json.read[/\A.*?^\}$/m])["dram_gb"]

    PTY.spawn(bin/"macpow") do |r, w, pid|
      r.winsize = [40, 120]
      # Power tree title shows the cursor position and row count, e.g. `(3/17)`
      refute_nil r.expect(%r{\(\d+/\d+\)}, 30)
      w.write "q"
      r.read
      Process.wait(pid)
    end
    assert_predicate $CHILD_STATUS, :success?
  end
end
