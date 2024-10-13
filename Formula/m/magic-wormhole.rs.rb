class MagicWormholeRs < Formula
  desc "Rust implementation of Magic Wormhole, with new features and enhancements"
  homepage "https://github.com/magic-wormhole/magic-wormhole.rs"
  url "https://github.com/magic-wormhole/magic-wormhole.rs/archive/refs/tags/0.7.2.tar.gz"
  sha256 "4a05dbf56688d6226d9094b783ccea7563207484bb81eb04393c09d163ce4791"
  license "EUPL-1.2"
  head "https://github.com/magic-wormhole/magic-wormhole.rs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "787ec6eaa0c9bec91e2588fe9831261fb16d231311046ffe5282d34fe495a431"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16ca89a8aa56791158cde2983a988072293c4973389c5821dae8e458954885b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf823dea1c6af29f7d2ac5f6043001b466059e86aee36a5663ff9d581495160b"
    sha256 cellar: :any_skip_relocation, sonoma:        "225bfd9f1050f8b1ad25ebcd31a100543287fe29b0e1b8ceda265f25a2264703"
    sha256 cellar: :any_skip_relocation, ventura:       "41646694d16377c695794c45389c1b1e9a9f6b34d2c7ec488905192b609445ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6102f747e734730fd5224527bd09b1d67c5258602ac4a661be036ef18acc358c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    n = rand(1e6)
    pid = fork do
      exec bin/"wormhole-rs", "send", "--code=#{n}-homebrew-test", test_fixtures("test.svg")
    end
    sleep 1
    begin
      received = "received.svg"
      exec bin/"wormhole-rs", "receive", "--noconfirm", "#{n}-homebrew-test"
      assert_predicate testpath/received, :exist?
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
