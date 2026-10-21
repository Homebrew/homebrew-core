class Gurk < Formula
  desc "Signal Messenger client for terminal"
  homepage "https://github.com/boxdot/gurk-rs"
  url "https://github.com/boxdot/gurk-rs/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "d047915916bceb221cd96a8afe53e5ba3b897f8d8798a4d36ca4cf354aa63b03"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a2a044c89ff9def760b5c0afdca76a58ccdaa6937168393dcc8bbddbb108ef0f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ca5ed55b3f40ae227a0b5511b4269515f73ab902d8bef446f6e21eacf898048e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6af23ce024bf98220ce30129fddf0a400dae460524e3b2eec81f5b4c17dafd18"
    sha256 cellar: :any,                 arm64_linux:       "10b9380b9b985e805c3a937dd072fc7cb73beaf956a4e7123f68b7f7a557ead3"
    sha256 cellar: :any,                 x86_64_linux:      "5de7ed544a644be54f8acff2317d32299dc6e3efd879718b952fd681c5b9142c"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gurk --version")

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"gurk", "--relink", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "Please enter your display name", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
