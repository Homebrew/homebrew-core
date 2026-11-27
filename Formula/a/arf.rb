class Arf < Formula
  desc "Modern R console with syntax highlighting and fuzzy search"
  homepage "https://github.com/eitsupi/arf"
  url "https://github.com/eitsupi/arf/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "7a145e05c6bec72c47f07718945b8f8b47b247f034c118a81fa0033de4160c0e"
  license "MIT"

  bottle do
    manifest_sha256 "b6ad8bde5ab491b7e02989dad585055f953be2e153f4cd20d534aae9753733de"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9de751c55c3add8afd79db48625f135490e8c92611668418938268be3bd3ae31"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "deb51f21664b8f3941dc845b6928d8ae2e814ac863dea6e98a1592d1196564b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5649ecffcce1e70d4c0c4f59e39b1272d7132914df7f1fc777c4e386b5853732"
    sha256 cellar: :any,                 arm64_linux:       "7ac033f54178b291cd22e3c5d88e5854f64c63e465883a12a8f0933e9121c62c"
    sha256 cellar: :any,                 x86_64_linux:      "22eb2b01c08e25a85be4e9db6b173b297bf43bbb8a7625bc50e4db8d2e0f62bd"
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
