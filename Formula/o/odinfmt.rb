class Odinfmt < Formula
  desc "Formatter for The Odin Programming Language"
  homepage "https://github.com/DanielGavin/ols"
  url "https://github.com/DanielGavin/ols/archive/refs/tags/dev-2026-04.tar.gz"
  sha256 "887dbcdb5418a16b52655bc0953bddf798919520123d5a3eb5d27a9125800d8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf86842ebd78a6adfa69033682517544d5831d71366f8199f471be466b8cf424"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6b22e82f5f36be370f3c5f43454243ebf4485f07500a421cf53b0f4cc72f673"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f554a4d414b8c88d44d44f97bb5f0da6dd93998492f084e4f47da973ea56ab23"
    sha256 cellar: :any_skip_relocation, sonoma:        "dccb4e55f68565760efccbed7412694489d61f367443a0cf0817eb7831ebe505"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea8ebb878f42bfcc65087a877c3590e5dbf0d286145894e68ffd44a1025977a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc3d7704bab8963af9fb1bdfff2b103a76095566a36fc25d183b1ae9eabec949"
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
