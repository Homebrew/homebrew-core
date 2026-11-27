class Gurk < Formula
  desc "Signal Messenger client for terminal"
  homepage "https://github.com/boxdot/gurk-rs"
  url "https://github.com/boxdot/gurk-rs/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "b5e5d40a03a9b96795c406824fabd9feed281e8a4d5b49235bd75f1d06edcc9f"
  license "AGPL-3.0-only"

  bottle do
    manifest_sha256 "663491d1efa98093ba9c910e79ba178de7628db730ea33ebad32d0f891d650c1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eeb799b1a836dfba06d1432264f0582c109ac61846d6016d7f360a90429252f2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d3716480f831ddc84851640edcbe9f46cb1960ae9bd668eb6d3c4960520f721b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dc03d4ad8248a84fc4e0f189610269a6c939c9533d382181a0bf66694a9b8c6c"
    sha256 cellar: :any,                 arm64_linux:       "563f48430584de1d074abcb69da08e93b6e4e5a3a7bf7360239848462c259a08"
    sha256 cellar: :any,                 x86_64_linux:      "0cce3cad9107a445c05838aa89a51a98f7e1f9d972e391bb5ce8aa4480adde3b"
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
