class Odinfmt < Formula
  desc "Formatter for The Odin Programming Language"
  homepage "https://github.com/DanielGavin/ols"
  url "https://github.com/DanielGavin/ols/archive/refs/tags/dev-2026-11.tar.gz"
  sha256 "9cbcb116d666075c51cf7c005faf7392a398c75e8adbea476d6a01f779793565"
  license "MIT"

  bottle do
    manifest_sha256 "59b3cc5dbedb234b6c8874373017c9ce384aed0d2d188d4685784b11a94eedb5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "10284b27f8570672c207ed3084a1a9ba3a85f07d5d4bf51fb01eaab1b8c4abc7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5ee4be269f0d1148c5cca6364a4fbb59af9df327e697f7b6b5490fb03591821a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "626e68176664c8c39b8b353df977c5c97834a838c9708ca87f0b215289ebdeaf"
    sha256 cellar: :any,                 arm64_linux:       "a8d1dfe34630ee4055bbf036bd0fda79024aab69d5a70444a9d414de4bad5cb2"
    sha256 cellar: :any,                 x86_64_linux:      "2f5ae02b8e252fedc96af1b11b66d6ff03ea9c9d6d323ea577543a6b19a4b4f1"
  end

  depends_on "odin" => :build

  def install
    args = %w[
      -out:odinfmt
      -collection:src=src
      -o:speed
      -file
    ]
    # Odin defaults to x86-64-v2, which is newer than Homebrew's oldest supported x86_64 CPU
    args << "-microarch:#{ENV.effective_arch}" if Hardware::CPU.intel?
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
