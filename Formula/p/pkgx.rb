class Pkgx < Formula
  desc "Standalone binary that can run anything"
  homepage "https://pkgx.sh"
  url "https://github.com/pkgxdev/pkgx/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "553019a0f9e67111568a6a193bcd63281e6252982d9a1d3835f1f0bc65313a0b"
  license "Apache-2.0"
  head "https://github.com/pkgxdev/pkgx.git", branch: "main"

  bottle do
    manifest_sha256 "e14001beee3d610d662872ea45cc7c94a6b647f37c49d4cb19a4a33ee9bdff44"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d7548ac6909cef11bff52d255fd1b55074244a410ce021f9dc32c1dd15c31de4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "30620d0360cce336169ad1a4e7aa63225d5801af5431580601a987d062bbe2c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "00dc6ba2028fb87a8b9abf86f7cebfcd83f1b01b4d583dc2220877934ad4a74a"
    sha256 cellar: :any,                 arm64_linux:       "518fb3dd56c12aa6d81aebc4f3dc8573b0ea90dedfe19dde0e63d99c95fe5d4f"
    sha256 cellar: :any,                 x86_64_linux:      "df6b8f9ae73472211a094969e224dadcdda02ab489e522f3bed4e9c486b85fba"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite"

  on_linux do
    depends_on "openssl@4" => :build
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix(dep("openssl").name) if OS.linux?

    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"main.go").write <<~GO
      package main

      func main() {
        println("Hello world")
      }
    GO
    assert_match "1.23", shell_output("#{bin}/pkgx go@1.23 version")
    assert_match "Hello world", shell_output("#{bin}/pkgx go@1.23 run main.go 2>&1")
  end
end
