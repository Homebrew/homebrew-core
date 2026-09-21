class Odinfmt < Formula
  desc "Formatter for The Odin Programming Language"
  homepage "https://github.com/DanielGavin/ols"
  url "https://github.com/DanielGavin/ols/archive/refs/tags/dev-2026-08.tar.gz"
  sha256 "e8d368f35b6833efa7e840753881d01f76607f3c0872c614e536f2b7e939f800"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0c4b537386ffad5a7472714b8959f88479480f581425783341e2d173459a7129"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "26ce7dfa2e94d18c691212443fb5dfe5dac27da298eace364b1b6788b9189a4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c97f51a703d9b38b53d1b05ea8a4696e57b15acb69c683263b65336e9721928d"
    sha256 cellar: :any,                 arm64_linux:       "82a3a0d6d61ef9cee1777874d867265912e79333f5125cf3bd1a421b8a0ec120"
    sha256 cellar: :any,                 x86_64_linux:      "941f7316382cef8d7780c045f7ec4b899b4c73ecdc99215df216404753ca54de"
  end

  depends_on "odin" => :build

  # Backport build fix for odin 2026-09, which replaced `ast.Inline_Asm_Expr` with `ast.Asm_Template`
  patch do
    url "https://github.com/DanielGavin/ols/commit/5f1b4d773b05d98dc9533521490096cf1a06a6d3.patch?full_index=1"
    sha256 "e76914e29a26bca835d115111c1017ec0e6f7d51edc93a8c0e1f9a1fbd7c6368"
    type :backport
    resolves "https://github.com/DanielGavin/ols/pull/1653"
  end

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
