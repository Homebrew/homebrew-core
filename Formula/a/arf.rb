class Arf < Formula
  desc "Modern R console with syntax highlighting and fuzzy search"
  homepage "https://github.com/eitsupi/arf"
  url "https://github.com/eitsupi/arf/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "46538c0598e7af96e74c784cb07c5f44a593e90d9031bfba09542b7168ce1ed4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "98fd21b0f8b8619a5a3bedb41873203d0ea65783f21c0c4a378a76e844c26cc2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "050d7c55e670560ce3298c05ec539257096c849299e26b349cd5ba27700c39b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9a871f3e167734f2ff5e0936b1bac33a597b5549bce92daf155377a5af79aab6"
    sha256 cellar: :any,                 arm64_linux:       "c586242685ee20ddd7008c657e775c65f1316741608662c12c0b501d4d9830e4"
    sha256 cellar: :any,                 x86_64_linux:      "60e87c514980a3b6e8a1c592f37f8b19c756363a385872c0f2b2355d656cc8c9"
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
