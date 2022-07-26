class Dura < Formula
  desc "Backs up your work automatically via Git commits"
  homepage "https://github.com/tkellogg/dura"
  url "https://github.com/tkellogg/dura/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "6486afa167cc2c9b6b6646b9a3cb36e76c1a55e986f280607c8933a045d58cca"
  license "Apache-2.0"

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"
    assert_match(/commit_hash:\s+\h{40}/, shell_output("#{bin}/dura capture ."))
  end
end
