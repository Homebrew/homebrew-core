class Meow < Formula
  desc "High-performance, rule-based tunneling proxy kernel"
  homepage "https://meow-rs.github.io/meow-rs/"
  url "https://github.com/meow-rs/meow-rs/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "e92c0979cd95f16246bfb763da7cab8d66f23a8ec914b61e5dd5813b29b68a11"
  license "MIT"
  head "https://github.com/meow-rs/meow-rs.git", branch: "main"

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
