class MagicWormholeRs < Formula
  desc "Rust implementation of Magic Wormhole, with new features and enhancements"
  homepage "https://github.com/magic-wormhole/magic-wormhole.rs"
  url "https://github.com/magic-wormhole/magic-wormhole.rs/archive/refs/tags/0.8.0.tar.gz"
  sha256 "c6cf7f9e5793488a275f525562d55f9edb03ab5ffbe0d859c2ea052fec05a08d"
  license "EUPL-1.2"
  head "https://github.com/magic-wormhole/magic-wormhole.rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e96efa80b44367e83104f74d56eabd4eae246852e0cbefbced41604e4d2a269"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e55ecc6f0f55258ab5612e89f93e86212af41a3ea38f4b3bb241425af79ed449"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd13363db07ed58675c61843da02e0af211980cfac5aa590eb29bde09a9a0e1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "99596794d9aee114584a49100fed6bd5fe8344e1cbb7b7abda98c4819275610d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c20a1dbf798ec4c8e3744fc006e8fb83840322fde44416c1982b54c58410c20a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc7e00c24774687f9f14a872e9737cb8f84fd18ad78d908defe3fcfa6d4a8e9d"
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
