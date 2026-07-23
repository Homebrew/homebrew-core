class Arf < Formula
  desc "Modern R console with syntax highlighting and fuzzy search"
  homepage "https://github.com/eitsupi/arf"
  url "https://github.com/eitsupi/arf/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "38e3af061b7f2a65c89311cb445aaa2680282efc65a3f12a7b945f87aed06b80"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c421d7fcfedfb26a17b75f542a5097101857423af4da2ceab31b78f5768a787"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd7580359dce3a768ffe361d3a1ee802f8402cf417f127c3b2cc1236608551f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c345a07eaf11ee6a969789bc5c70ce3b999d8a72ca81821dcc286532380dcb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcdc195faac6161888efa3c6c5f17bb91a027db0538e4f29d2f38c098b6251fe"
    sha256 cellar: :any,                 arm64_linux:   "0935256e3bae07c5da91f063bd520de895d815617430f84f243bd43ce9581fb0"
    sha256 cellar: :any,                 x86_64_linux:  "5729a4036c3cbc7c68afa3dbffc1d806a14d7cd133e909e5718034efba4dc00c"
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
