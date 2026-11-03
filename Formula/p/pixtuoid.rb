class Pixtuoid < Formula
  desc "Terminal pixel-art office for AI coding agents"
  homepage "https://github.com/IvanWng97/pixtuoid"
  url "https://github.com/IvanWng97/pixtuoid/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "49a430b2b6725f788455e87de7d70feae8da2c4d9376696d37298c297242391b"
  license "MIT"
  head "https://github.com/IvanWng97/pixtuoid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eafbcb1f07367672bf9c9d8f459ad58489f0254747d8032afe396652d46f112f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0853c8bf2c552b3fc5c0c2d680adb970b9f56784129f2e60f5c8c95b1aed2d00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2639c09bbbbd1c94550fb56937a37f86cfc9786488e710c1e8c90fea673a1b2b"
    sha256 cellar: :any,                 arm64_linux:       "290e8549ca81076f871a0f6eaa0e4a4a661a34a845bd3dcb15f3ea9b7efdf8f6"
    sha256 cellar: :any,                 x86_64_linux:      "44dc5f45cc8f22aa6f0c179a871e15ec4fa90e1b7ae5a1cc491161bcc40ed319"
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
