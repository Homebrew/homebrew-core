class MagicWormholeRs < Formula
  desc "Rust implementation of Magic Wormhole, with new features and enhancements"
  homepage "https://github.com/magic-wormhole/magic-wormhole.rs"
  url "https://github.com/magic-wormhole/magic-wormhole.rs/archive/refs/tags/1.7.4.tar.gz"
  sha256 "f7b0ff163542da784340c3995b5076032d717f39b9c3ab980b2f15777c09c68d"
  license "EUPL-1.2"
  head "https://github.com/magic-wormhole/magic-wormhole.rs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11707cb0b64b1a5082f1dda75d2d499d18fe2e62efccc28b5e254245e983bd50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bde29ea50cd93af504b2048425bd0f0adbd4968639c6b68d0e4349f5dab07614"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b50810f239eceb1401f4bbb1ca8268e013fd104f4d5140927b0bc33578e946b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0ef9ca867b85cad21f24c3bfe29c9c219c1b4ff1ff8f58dbe21c835676be887"
    sha256 cellar: :any_skip_relocation, ventura:       "0a1519f2c3ab5b20b11c310584f731d973865856aa1ab512b1e3ded39c13f0bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b89af0f49d3d3059549eba8401ffb16342bff900aa8a8c1874d324c8bb3e0bd"
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
