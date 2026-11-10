class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.13.0.tar.gz"
  sha256 "b44d00a0f9b4d0ee4cdf8b7874285ef47876651847ac4b26e28b07ed1338e185"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f2827f3b5584f0d2c2eb4f76fadef7b93518bb899063f717739a2ce0804ce064"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "87cfb31ded9a7c75a3325ef7b56b8dfa3c2c14c653f11bcd2dd147b39e621a59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0dc94fe4dd8ad9b2982a1a0859cd7f8216c2c62ea31b45f71bf5684b6ecc507f"
    sha256 cellar: :any,                 arm64_linux:       "46cfb089f3667b12db29cc9a26916a9aa7c589057f1cdb50647d46f6e50b7199"
    sha256 cellar: :any,                 x86_64_linux:      "e36ee9b5a244e6d5f43b925efcaf1179bd46af0acca1a7de0ca026f65f40040b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"lis", "complete")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lis version")

    (testpath/"hello.lis").write <<~LIS
      import "go:fmt"

      fn main() {
        fmt.Println("hello")
      }
    LIS
    system bin/"lis", "check", testpath/"hello.lis"
  end
end
