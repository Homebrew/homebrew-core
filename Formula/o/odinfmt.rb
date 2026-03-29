class Odinfmt < Formula
  desc "Formatter for The Odin Programming Language"
  homepage "https://github.com/DanielGavin/ols"
  url "https://github.com/DanielGavin/ols/archive/refs/tags/dev-2026-03.tar.gz"
  version "dev-2026-03"
  sha256 "7c0d9e0312d5dc0d49e1696b98217932838e1b132feb2a68950e6fa7d6d4a2ea"
  license "MIT"

  depends_on "odin"

  def install
    system "odin", "build", "tools/odinfmt/main.odin",
      "-file",
      "-collection:src=src",
      "-out:odinfmt",
      "-o:speed"

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

    assert_equal output, expected
  end
end
