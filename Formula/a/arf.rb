class Arf < Formula
  desc "Modern R console with syntax highlighting and fuzzy search"
  homepage "https://github.com/eitsupi/arf"
  url "https://github.com/eitsupi/arf/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "8a00d9786aff0c7b00907e425bcce64c1de6b94279e444db2a3c3810208d1eba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d04d0a6b8db1d858cd34231021a93f547616d2cb41f5915f97061e7f0c96ce91"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "376493f0e9e722b60bc3f636e6be18a35504b779a8d3bfc8ca1880a94db7c9a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5776a4b8432cc8cd6c00272eadfc25fbe85119be9cbf6132accd828165dea0f5"
    sha256 cellar: :any,                 arm64_linux:       "71fa8349b3ac81d3ca632a54ae6d333929b5eeee24272074775e8d3beb647d9f"
    sha256 cellar: :any,                 x86_64_linux:      "0e228dfb67c680ae56d9fbe8223daaeb723a0d6d1701c76d30a0e0eff85ac2b1"
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
