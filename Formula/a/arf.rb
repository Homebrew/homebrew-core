class Arf < Formula
  desc "Modern R console with syntax highlighting and fuzzy search"
  homepage "https://github.com/eitsupi/arf"
  url "https://github.com/eitsupi/arf/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "34647ecda535521c18dd26dc2b609c390b02876f47e76d661750bb44ca9fc602"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0f3056a787006d50a3f030e9ecdd649393c69d9d60b8328dd74a75f29ddff656"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f20511ed1c3cfac855c0cb30a8751d3fe2357a98e2c82417e7b41a654d2e0b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "01ff6b919243d64d473ee00c4db0a399785c7edfdc9771ab80685196389307f3"
    sha256 cellar: :any,                 arm64_linux:       "2f174f5399ef721f298f5b1e8a71f793674e6975c4bd39171fb93544999de5aa"
    sha256 cellar: :any,                 x86_64_linux:      "65589e48555d830088f91207b95ab6ce26ada088177a38247be432335c9e80f1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/arf-console")

    generate_completions_from_executable(bin/"arf", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arf --version")

    system bin/"arf", "config", "init"
    if OS.mac?
      assert_path_exists testpath/"Library/Application Support/arf/arf.toml"
    else
      assert_path_exists testpath/".config/arf/arf.toml"
    end
    system bin/"arf", "config", "check"

    assert_match "history", shell_output("#{bin}/arf history schema")
    assert_match "sessions", shell_output("#{bin}/arf ipc list")
  end
end
