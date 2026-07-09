class MagicWormholeRs < Formula
  desc "Rust implementation of Magic Wormhole, with new features and enhancements"
  homepage "https://github.com/magic-wormhole/magic-wormhole.rs"
  url "https://github.com/magic-wormhole/magic-wormhole.rs/archive/refs/tags/0.8.1.tar.gz"
  sha256 "90e8b1d7270a4c251f78376e10948c994df1a559152eca7eedd4aecbf70b70d9"
  license "EUPL-1.2"
  head "https://github.com/magic-wormhole/magic-wormhole.rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb6fc9ebd5dd3e8938121a9f5fe30a7f4da6761a6149aaa397815cfc55c4e730"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13959efef8fb4cf5e870c1985756dd83b3ec84cda92716d23ca10495af073a58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dae9b37b7d39c8b1cb28ce41a30e7dae0efcc83a7c83519bc868afe016087c73"
    sha256 cellar: :any_skip_relocation, sonoma:        "7816b8449b9c690c720d749c983c63daf3bd746ab332cd4673db098005b991b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5ac2b3ba20334153bab8f4360dc54576119c1ddb71306d2aa0c0e8bc7db79dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45aaddeca394e30d8e3e55fb4e9a707776dc37ecf146d79bcf15820741c99244"
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
