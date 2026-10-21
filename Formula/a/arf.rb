class Arf < Formula
  desc "Modern R console with syntax highlighting and fuzzy search"
  homepage "https://github.com/eitsupi/arf"
  url "https://github.com/eitsupi/arf/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "e46300adcbbee5e6349c63bab2b2cdd863f99baea82e6ce85eb5c86d8dfcbd0c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ef60436033bf6a0f71258be763d4ca30efce21795bdb3aabe23a1f63505aed39"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70e1991beadea8973eb7086b594c0649800603a9e511430449510ec054ebff7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d551c99202e0d001bd31ea5e5af6a981c4be5b45850785d02d5ad761aa9933ca"
    sha256 cellar: :any,                 arm64_linux:       "faa9e4f2375556bdeac759c5b3b731144c772a863d8a8ef0aea29cc4601f51ea"
    sha256 cellar: :any,                 x86_64_linux:      "a8a727e371e263b10283b1c3a7755a685c84b339ed051af3f1ca64e2d5c08bf5"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
