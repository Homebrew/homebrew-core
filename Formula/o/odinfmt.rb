class Odinfmt < Formula
  desc "Formatter for The Odin Programming Language"
  homepage "https://github.com/DanielGavin/ols"
  url "https://github.com/DanielGavin/ols/archive/refs/tags/dev-2026-05.tar.gz"
  sha256 "387b9f47304abab5c7cbe12f041c85de892ddc94a54e03f2789ff6ac9fc16386"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30b2ae021be0765ffcaacf7224a586a6733e0e69793035372c75784e7ff837c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbf3261e6fc07e272c5a5209a1392ee9253f543b5dc7b88fecbe402ecdac9a01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53bd17fd9bf54d9d6a516237daddf8d52afcad5f2a8582438378e9d2b975f19e"
    sha256 cellar: :any_skip_relocation, sonoma:        "39179f6a02be59aa32e2052b968dad99975808d15d8498381f9984927a96f35f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7563e87f1fb473998245d26b8389d638e7e2387eafd662c3e4c9db637e3cdc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73da0f82098fb046542067e5b89a45024755623cd82064d071ca97691f61631a"
  end

  depends_on "odin" => :build

  def install
    args = %w[
      -out:odinfmt
      -collection:src=src
      -o:speed
      -file
    ]
    system "odin", "build", "tools/odinfmt/main.odin", *args

    bin.install "odinfmt"
  end

  test do
    input = <<~ODIN
        package main

        import "core:fmt"

      main :: proc() {
      fmt.println("Hellope!")
      }
    ODIN

    expected = <<~ODIN
      package main

      import "core:fmt"

      main :: proc() {
      \tfmt.println("Hellope!")
      }

    ODIN

    (testpath/"hello.odin").write(input)
    output = shell_output("#{bin}/odinfmt hello.odin")
    assert_equal expected, output
  end
end
