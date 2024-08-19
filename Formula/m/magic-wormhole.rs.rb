class MagicWormholeRs < Formula
  desc "Rust implementation of Magic Wormhole, with new features and enhancements"
  homepage "https://github.com/magic-wormhole/magic-wormhole.rs"
  url "https://github.com/magic-wormhole/magic-wormhole.rs/archive/refs/tags/0.7.1.tar.gz"
  sha256 "c6e2acd3cccd982f449d26184d714d4cf813f51b8b75b3e36ecbb78565b3f4e8"
  license "EUPL-1.2"
  head "https://github.com/magic-wormhole/magic-wormhole.rs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a00766d0955048fce61802525debac9d734f9f7f392a916f10e2024abf67426"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e2a75ab3f8ffb0a6b5f2a43784e9e811696293005ff8d0b243c18add7169758"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "130f3fef715a4e6b83ca78d0dca0c1a186a77d463ee0071708339cf32dba0fb3"
    sha256 cellar: :any_skip_relocation, sonoma:         "fbf23452aedcb7a59ea57a9d82067001b05f18bc306a6b0dc0dbecf3db8d0d64"
    sha256 cellar: :any_skip_relocation, ventura:        "8a1bac6e095cdb11373f593bcb87df85217356fa0815c790b9ad35ed3d340221"
    sha256 cellar: :any_skip_relocation, monterey:       "1f6bd3888b10ac9eaa3b051473396962dcb3d2df4a05af21efce3ff6dec9f055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7345e96205efd22976c26df9441f343e8c997e837fb9034efec0265144201fd"
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
