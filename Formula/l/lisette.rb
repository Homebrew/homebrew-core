class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.7.0.tar.gz"
  sha256 "cbdfbcc846dfc86e9c3962da209c7b64ba2274c9b59830e6961276fb1290c687"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95ae834491efe499380d19b253a7a8528f43a8093e93553c3fa7c34c26b97ae5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d105d4f3e93c7084a1a78ee748e40a7febda2d9511d085e17f3dc16a63c9b56e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df8283888c474942f654fd8685e4d3c82923e38bed4c3734ce5ec8358c9337ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ad0424d4843f1132adedae115040fd0522a4f0599199cd5621c9b3caec7a134"
    sha256 cellar: :any,                 arm64_linux:   "c179d909b4029f43b64068b7a996647cf15f1e3e1b066ecd659cea77ef17dfd8"
    sha256 cellar: :any,                 x86_64_linux:  "9124c09819e5f931ad16e35732c53e567c16e94405fb82db42cfbf86f5cedfa2"
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
