class Pixtuoid < Formula
  desc "Terminal pixel-art office for AI coding agents"
  homepage "https://github.com/IvanWng97/pixtuoid"
  url "https://github.com/IvanWng97/pixtuoid/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "49a430b2b6725f788455e87de7d70feae8da2c4d9376696d37298c297242391b"
  license "MIT"
  head "https://github.com/IvanWng97/pixtuoid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "08f4d1f0f15af034f7ad20f25bf1cab451a7d3d41fa7d64899f115b660961e18"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8309fa900268b62ecbaf6735228886fcf4642be6c8a63f03f5ab05e97c87cc00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "176f28b8827d41eb01f5ec7ee7ac8f70594a64d6939097586ef9678360f16392"
    sha256 cellar: :any,                 arm64_linux:       "ca1b455d016b3c13214aedde6bf8a4aead12a658276e4db1aa9bc9a78b99280b"
    sha256 cellar: :any,                 x86_64_linux:      "5d61863b8ddd169d633269cfaf29f0e1bc68ed686d28d2da6a5d4f632f2602ee"
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
