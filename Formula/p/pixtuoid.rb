class Pixtuoid < Formula
  desc "Terminal pixel-art office for AI coding agents"
  homepage "https://github.com/IvanWng97/pixtuoid"
  url "https://github.com/IvanWng97/pixtuoid/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "195e94c082e4a16170709a3ee5f884980aa4eac6d1b5a1c67a507e3f324dcb45"
  license "MIT"
  head "https://github.com/IvanWng97/pixtuoid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e227a6697e13225f35e8a79546084b44f26f507a9e289f6849bb019511c09162"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f02f741bfa0738ce0f9205d9e4a6a3e676f6ae5ba92fb699922de07728c3c3ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "489aa00aeca111808c21630cc0101b1ac4521fd47f3672ad10a1b43785fd0c0f"
    sha256 cellar: :any,                 arm64_linux:       "2b71445dd74db41037378c3ff067809119572f973e57fac82f4a34dc7f8111a2"
    sha256 cellar: :any,                 x86_64_linux:      "f4a453516e8cfb74fb7292929b39af5fa86882dad1b835db6a1d203171bb4c35"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    # Drop upstream's x86_64 Linux lld linker pin
    rm ".cargo/config.toml"

    system "cargo", "install", *std_cargo_args(path: "crates/pixtuoid")
    system "cargo", "install", *std_cargo_args(path: "crates/pixtuoid-hook")

    (man1/"pixtuoid.1").write Utils.safe_popen_read(bin/"pixtuoid", "man")
    generate_completions_from_executable(bin/"pixtuoid", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pixtuoid --version")

    connected = JSON.parse(shell_output("#{bin}/pixtuoid connect claude-code --json", 1)).first
    assert_equal "claude-code", connected["id"]
    assert_equal "failed", connected["outcome"]
  end
end
