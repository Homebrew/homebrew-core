class MagicWormholeRs < Formula
  desc "Rust implementation of Magic Wormhole, with new features and enhancements"
  homepage "https://github.com/magic-wormhole/magic-wormhole.rs"
  url "https://github.com/magic-wormhole/magic-wormhole.rs/archive/refs/tags/0.7.6.tar.gz"
  sha256 "1d76e80108291f0a31e1a0e2e1d6199decb55bec73bc725baacb93ea0ae06e5e"
  license "EUPL-1.2"
  head "https://github.com/magic-wormhole/magic-wormhole.rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39364a5af652c25322b8a54c683a2e79be6d37899841f8e233094bb3b529e874"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a058269ba3e3e3c576f06dee4eb6a70314d3c0dd0719d515e6f56e33e111992"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a24e2037972109a21496b081c6fa088bb6b8b25f62f68a809f3a8d072a11560b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94c8ee7bcc6387c3c52241a68a2477e615d39507720fe119d839b378274b09c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d314198a3901d447399ad6ebd117abfec4ab8cd0f54baf6b5b3e9abcfff9175e"
    sha256 cellar: :any_skip_relocation, ventura:       "9abb33389fee9aa69696240610c279ca352f31288734567abcab358b2d6f5316"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a29c5e0d8c9519a3d2ac5e19c27bcdd43cf9541f95a30c9610f71ccdd2fe586f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e782d1de02d84ac02c48447eaa78fca5a60b23d3131d3f661683f2ce41ec734"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"wormhole-rs", "completion")
  end

  test do
    n = rand(1e6)
    pid = spawn bin/"wormhole-rs", "send", "--code=#{n}-homebrew-test", test_fixtures("test.svg")
    begin
      sleep 1
      exec bin/"wormhole-rs", "receive", "--noconfirm", "#{n}-homebrew-test"
      assert_path_exists testpath/"received.svg"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
