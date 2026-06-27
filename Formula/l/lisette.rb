class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.5.0.tar.gz"
  sha256 "02997faaac860e799e185d5d7cf4f9b08fb0444cc1c6bb02ecabc3228b34cea4"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "949489bccb80fb16d85b1a01be26d824ebc1f18a207f422b9159d6958204595f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ea0255f1702f9b4050d2ffa69850b72f9c7e08e5c073a5e4d08985282e504f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3168504096ba37009b1061e3cff4fba722a7bdf9339c6da0d3e8d6cb4d6a1bcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e02dde26c3f3741edcd935cc23aca2c16431a0d2180a4b2f6f65176f068dffc"
    sha256 cellar: :any,                 arm64_linux:   "f173b9a5e56e9d3f0c874517c5616c557eda7f252c9ea93ca6f05b52599c0964"
    sha256 cellar: :any,                 x86_64_linux:  "e2fb75674b85f40b0d2ed408be5972cab395e31196f7b9fe5d3b00723d7c0b42"
  end

  depends_on "rust" => :build

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
