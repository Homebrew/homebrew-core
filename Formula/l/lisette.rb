class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.3.2.tar.gz"
  sha256 "d314090007e17c3ece9c8a4f97e49565f44140a602456bdcde831e49b755c8db"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "339a5298ec556e1c2a19d8ce122df738e8f4a023db14348f86f546a219b4d515"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84a4eb75e8fc684fe0603cf347bc50dc6bc5ff09b36ebd6f3930c79e951da2ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13ebc0cd59ca5ae4fd358d703be75f2c2148396aba777cc3cf9fac5fe5890705"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8fee00deb5d33e6fad7738d1fee2ed461ac1bbbdd3e9307fd7693c2f393f34d"
    sha256 cellar: :any,                 arm64_linux:   "21aa9706a8bcd176bc7d66a54183b196b8f82df342cd15be13dc31f7f26a15e2"
    sha256 cellar: :any,                 x86_64_linux:  "4b8778bebd9a4a7a72ab4af9f71cb5ced4a393a3b3de91c940dc54b98f710b65"
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
