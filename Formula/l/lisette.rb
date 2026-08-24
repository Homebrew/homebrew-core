class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.11.3.tar.gz"
  sha256 "419ddf1a3dd565f83106e314d5879ff5ac2a7cd97a50693f60f88193f40b6269"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "305179d45277d9b7b891c8edfa79f43a23ec31ab5af6955eb8658867b645cae6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0036380a8f74f764718f435f32e90cb904e1d68ef08db69dd7686be47a6f008c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8774c2f5a61ff72b092666339c1d37af22cf76b418f04bef9e893dbea52c28e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3cb1b7768397f3c81a8881c1afbe047ce8e184cf2a572975342f3d0bc31ea88"
    sha256 cellar: :any,                 arm64_linux:   "3449e00d705c59dc27d236cbbebfd68f5a51379d5809aaa41d5e66b972816257"
    sha256 cellar: :any,                 x86_64_linux:  "4587139e5076d1b56c9f9e426e1b4a0132c87688f19beccba220f64a184df9ed"
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
