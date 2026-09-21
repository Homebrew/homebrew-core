class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.12.2.tar.gz"
  sha256 "c01bd15f8fdd34032ad519ae4ad50959d11373a7a0316a2726161cf2f2c211e4"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a0c769e9535089cf15709d20c66fb2987c39be5392dd3f15fdfb543224ed2a2b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7571075c7edeacdd6b0f345f789bd49f511ea8b4e56dcc4be16aa884bb2a01f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0ee74e5db3f437751e28b5a42064cb90efd8125e57e010e2d1d0d7b4787f1a90"
    sha256 cellar: :any,                 arm64_linux:       "6ab6c1bd29887347ce69f536ee6705ca6500bc52b692c31e6810d5a4230f6c72"
    sha256 cellar: :any,                 x86_64_linux:      "bcdfff9eccda4f6b408540d1f91c4c6a3b3d73320f755491f1d1dcb657fd810c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
