class MagicWormholeRs < Formula
  desc "Rust implementation of Magic Wormhole, with new features and enhancements"
  homepage "https://github.com/magic-wormhole/magic-wormhole.rs"
  url "https://github.com/magic-wormhole/magic-wormhole.rs/archive/refs/tags/0.7.7.tar.gz"
  sha256 "bf3eb617b5d885f5e7d6ab0a25b5bde63033909167489626f04b8e40df4c7cde"
  license "EUPL-1.2"
  head "https://github.com/magic-wormhole/magic-wormhole.rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a86cfb953c24657c167c1cfe9b581138f4d296fb141f453128bcc376304cb740"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c2bcf6e0e0283685511f3b42ff52409134eadf5d024b828974bdb871f3e72df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c14712694fbcb0ae96945c0533f9f4fe2c214bd03e78cba5fe05e893e531ddea"
    sha256 cellar: :any_skip_relocation, sonoma:        "8861c8c79240a77f2da43f07856e7d52c9b22c7fcea8d68fbe50b7897d47716a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32c76321e07f47356777edb823ec0e48d66dbf6d2940e6ac46ce30025c257552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57abd516212ff9f82b34e61be9241ba44dbb5c96f88e93a9054d09b11a50e0fa"
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
