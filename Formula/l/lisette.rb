class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.12.4.tar.gz"
  sha256 "1d87ef4e392e596b4adb788f72cce7a272c69781d15a3e6eb98babfa7798faee"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6130ec3d3c67ba7f1b09d5a004448663acf7b1de58a9d4206538a8ea2d195d49"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7e2962a5f5231423a20580a65b35ee14443df0f1638d6fdccbfab2f34af035c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c5042c6e4081481484ac27b2206b8cd41e0c9f83cb8ed14ef25196774b9689e1"
    sha256 cellar: :any,                 arm64_linux:       "55c49ed661cc8133b5e2b9c6a49279cfc558ce83248fb2dfe9af49c5bc82abe9"
    sha256 cellar: :any,                 x86_64_linux:      "392517ac8b6071581d88892415fef31f6988c9d8e5d021eddd389af1ce4acd5e"
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
