class Pixtuoid < Formula
  desc "Terminal pixel-art office for AI coding agents"
  homepage "https://github.com/IvanWng97/pixtuoid"
  url "https://github.com/IvanWng97/pixtuoid/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "78293abd3691e5b8ce747490f5588ade49f14e31c6b7dda5ea4ffe5a893c29b9"
  license "MIT"
  head "https://github.com/IvanWng97/pixtuoid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ef6b7fabe3d8fedd07f003f6888320f860c31a982d02c14d95e4e9ff4dea53e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3f853764bb3f28f5ee1fb927819c8dea4a08595091a522765f54aaa628a989be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d88e3ee2ad45a3a97670561412204a9f9606ca7963ef5c3e851be2e844cb9453"
    sha256 cellar: :any,                 arm64_linux:       "cda8a7cfef9afa967655b593424923ce84d4f56e44dd2e52c6de028cb60a7b6a"
    sha256 cellar: :any,                 x86_64_linux:      "cd7b09c3a3779692b78805a579953bde6cefb78d43882aa66fe615a4934ea918"
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

    system bin/"pixtuoid", "init-pack", testpath/"pack"
    assert_match "OK: pack \"skeleton\"", shell_output("#{bin}/pixtuoid validate-pack #{testpath}/pack")

    require "json"
    connected = JSON.parse(shell_output("#{bin}/pixtuoid connect claude-code --json"))
    assert_equal [{ "id" => "claude-code", "outcome" => "connected" }], connected
    assert_match "pixtuoid-hook", (testpath/".claude/settings.json").read
  end
end
