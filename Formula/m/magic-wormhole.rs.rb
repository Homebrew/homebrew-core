class MagicWormholeRs < Formula
  desc "Rust implementation of Magic Wormhole, with new features and enhancements"
  homepage "https://github.com/magic-wormhole/magic-wormhole.rs"
  url "https://github.com/magic-wormhole/magic-wormhole.rs/archive/refs/tags/0.7.5.tar.gz"
  sha256 "b0560c3310e7ab3c9361d6eae7a471658ed5b5ac991f22094b8e737c8f6f1a64"
  license "EUPL-1.2"
  head "https://github.com/magic-wormhole/magic-wormhole.rs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0b49e021f9139b9ad21f90a9a94be31f197642400626394a62e1f6917e163e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2402ed9a4cf685e07dc1d85e007c1cab5c9677ada4bc1cec5d0f99e32cd033e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa6f077f88352fb495121281f716404269b340c09248f077a873b3fadd2ef3b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0502598e8d284804ece531825870bf1a2c3839ee651c79fdf1f0411fae5ac2d"
    sha256 cellar: :any_skip_relocation, ventura:       "9a3f50cf5584e1c85d828309012027fa693519b6e275b843ea9b01dab62ca3fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c182159ac0fed782a8d89767cd133f97cf340af722941f09e6b5c1691e2bf31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7753ab72d6c4140a859107ed211290441565e8f19c2c5f097f70a9fafd1e1b0f"
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
