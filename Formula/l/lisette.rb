class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.2.10.tar.gz"
  sha256 "b526bfaf4953bb5fcff3f5ed84981e98f943e7d8af2efb77807288229f169a42"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d09405ace3e9628f048091dd7e2658d5410fc17c04f90233b20eb47b7456db2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a9cbb5e29cfa1c63a1422f59d3eb92b7c95043a664faf7ecab9ebd8034797a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b32613381818f4467434c9bc351bd1df723988485fe0ac216183ebbae99dc5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8c7b055e43d6e231c83e2524110ec52609fa15c28420352cf8846d065677ebb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "214079219e3074bfd9b86ac022a096f9be5bf96584ad0aeeb27e5109402cd7c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58d5bede29b359229f5359fa6fc84154ba7ad5149f16ecb6154a40b48e8b6644"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"lis", "complete", shells: [:bash, :zsh, :fish])
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
