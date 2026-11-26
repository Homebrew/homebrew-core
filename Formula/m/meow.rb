class Meow < Formula
  desc "High-performance, rule-based tunneling proxy kernel"
  homepage "https://meow-rs.github.io/meow-rs/"
  url "https://github.com/meow-rs/meow-rs/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "2d3ef7f76907e45713345c4a8e7148ba5279d6a45d3d6e90b4848fae7249fe88"
  license "MIT"
  head "https://github.com/meow-rs/meow-rs.git", branch: "main"

  bottle do
    manifest_sha256 "8b9b51d793b7c0bd9c0ce3494a6a921005c35a020e8835eaad7a77a593640cdb"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "60d1d19e5ac34478fac27ca7c8c93de8b6ff6948ec8fc2d349e49f16e978eafa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a15e030738f258f96b27bc02df92aaec4a200d7f5e81eebabcd78202313fd008"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9117285c656f42526c0298f677f3a2a225ab20b4f59f6d4b3f4a982f072415c8"
    sha256 cellar: :any,                 arm64_linux:       "db524414d58909f0b3127f2ac561749c0adb50c5b25e7817720601f929b78de9"
    sha256 cellar: :any,                 x86_64_linux:      "7877041983b4135801b216b22ce2c44380b6fe7e38f40f9e49772cee2a616c58"
  end

  depends_on "cmake" => :build # For the vendored BoringSSL library
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # For libclang, used by the boring-sys crate

  # `test do` binds a local port
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/meow-app")
    system "cargo", "install", *std_cargo_args(path: "crates/meow-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/meow --version")
    assert_match version.to_s, shell_output("#{bin}/meow-cli --version")

    (testpath/"config.yaml").write <<~YAML
      mixed-port: #{free_port}
      mode: rule
      rules:
        - MATCH,DIRECT
    YAML
    system bin/"meow", "-f", testpath/"config.yaml", "-t"
  end
end
