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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "30591b28eac7458c7fe82f690f9abf26ff89f6c77e5d80b937e5af19810fe97c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7d03f6c784f2af92a6a6067c50673f48a45b2eddf263bd7073e0781613d33177"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "11bc9657c4b37453c36b390b0b36b9d05b1baafd8551babaa39a4e0d8079a4f6"
    sha256 cellar: :any,                 arm64_linux:       "c9503cf5857cd16be6847a245076c2c421b31018268c73f0aeb8d464a8c680f6"
    sha256 cellar: :any,                 x86_64_linux:      "0623d5f5fa220c1292e8e49f4429936d3f0929ecc4cdc40e4967124852c03738"
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
