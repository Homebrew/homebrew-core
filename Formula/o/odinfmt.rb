class Odinfmt < Formula
  desc "Formatter for The Odin Programming Language"
  homepage "https://github.com/DanielGavin/ols"
  url "https://github.com/DanielGavin/ols/archive/refs/tags/dev-2026-10.tar.gz"
  sha256 "49ce783760429421645f6b4125dda374154148fdfbcb66fce61f772dbfaba851"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d7204e2cf8978a8ef3b16ca73d3b002eb2773c594cd1d07fa175088be6ff2722"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d5fc59dbaa066ed0bd649145842793f5c987e09e06d20ecbaf7e4969df21c190"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5e619175a3b0e58308d0fcb7c5fe11b4c4de1670afee2e8ba89f97c2203ef991"
    sha256 cellar: :any,                 arm64_linux:       "8a2e83aee3af156bc579a5f86ab8d8af6aededf2bd7d8378761be7f85bc67e93"
    sha256 cellar: :any,                 x86_64_linux:      "cf441bc58150c14a9c817b63dbae8d1fde699bbbf90d4880fbe5335e985834e2"
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
