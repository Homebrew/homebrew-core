class Meow < Formula
  desc "High-performance, rule-based tunneling proxy kernel"
  homepage "https://meow-rs.github.io/meow-rs/"
  url "https://github.com/meow-rs/meow-rs/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "e92c0979cd95f16246bfb763da7cab8d66f23a8ec914b61e5dd5813b29b68a11"
  license "MIT"
  head "https://github.com/meow-rs/meow-rs.git", branch: "main"

  bottle do
    manifest_sha256 "d8a26fb6c74c4d2bfbd63e79df3c15df1d4fe93dc7e0870c7811729041a1f03a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "907c388993675f1684877b26a6db5ceac696ad62cb435b3bf2cf4e37ade390b9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5347bf4b9acf4e7006892a87b125dbe6030a96aa02c5f5af995d88e638cdd750"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f6dd46e1f73a4c803a69d6290727c7047cbae83393e3b44ab8a8f7ef4f04f1b8"
    sha256 cellar: :any,                 arm64_linux:       "cae55ea93b8c04bc90f55930764f05eb346d257c8a77d3800491bdf6610e9e48"
    sha256 cellar: :any,                 x86_64_linux:      "2b5d9c0554679b5c5873466a51fd6757f53205ccdee561b7b1984cd68a945b4a"
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
