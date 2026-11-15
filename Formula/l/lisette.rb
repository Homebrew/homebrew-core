class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.13.1.tar.gz"
  sha256 "87a479e2bb6c70da7cc9321bfd48a41cf85bab9c052a60ecba1633cb92fe8b45"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3d69a449e1dae49ce8a4cef64debd0ed8ccab9db77ccb6dcd08c7d2e69f819af"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "61453a0ea15805fb6bd7c7587b469db8008d1fb57c52413943277067af28d4f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ce2934b9810bf086903efcdea44a8d7252af646e7491d9a9cc1aaea8d5fbbcb3"
    sha256 cellar: :any,                 arm64_linux:       "c362211f041d0b7754d59d31a32257fd276c2d0e299e0208a8300a2949b3f89b"
    sha256 cellar: :any,                 x86_64_linux:      "69157927d5664081fe00afca4700815767e3fe77678ec491ab9b84afef4e8d07"
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
