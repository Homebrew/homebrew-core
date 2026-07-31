# ============================================================================
# Fusion v2.0 Vortex — Homebrew Formula
# ============================================================================
# To submit to homebrew-core:
#   1. Fork https://github.com/Homebrew/homebrew-core
#   2. Add this file to Formula/f/fusion-lang.rb
#   3. Run: brew audit --new fusion-lang
#   4. Open a PR
#
# To install from your own tap:
#   brew tap QuantumSecureTechnologiesInc/fusion-lang
#   brew install fusion-lang
# ============================================================================

class FusionLang < Formula
  desc "Modern, polyglot systems programming language with post-quantum cryptography"
  homepage "https://fusion-lang.org"
  url "https://github.com/QuantumSecureTechnologiesInc/Fusion-Programming-Language/releases/download/v2.0.0/fusion-lang-2.0.0.tar.gz"
  sha256 "2b5fda4f40d7104de1a934775eabb4396a024e7bd40f9765a568d180d2035899"
  license "MIT"
  head "https://github.com/QuantumSecureTechnologiesInc/Fusion-Programming-Language.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Build the Fusion compiler (fuc)
    system "cargo", "build", "--release", "--path", "crates/fuc", "--features", "llvm"

    # Build the Fusion CLI
    system "cargo", "build", "--release", "--path", "tools/fusion-cli"

    # Install binaries
    bin.install "target/release/fuc"
    bin.install "target/release/fusion"

    # Install standard library
    (share/"fusion/stdlib").install Dir["stdlib/*"]

    # Install documentation
    (share/"fusion/docs").install Dir["docs/guides/*.md"]

    # Generate shell completions
    generate_completions_from_exec(bin/"fusion", "completions")
  end

  def caveats
    <<~CAVEATS
      Fusion v2.0 Vortex has been installed.

      Standard library location: #{share}/fusion/stdlib/

      Quick start:
        fusion init my_project
        cd my_project
        fusion run

      For more information: https://fusion-lang.org/docs
    CAVEATS
  end

  test do
    system "#{bin}/fusion", "--version"
    system "#{bin}/fuc", "--help"

    # Test basic compilation
    (testpath/"hello.fu").write <<~FUSION
      fn main() {
          print("Hello, Fusion!")
      }
    FUSION
    system "#{bin}/fuc", "hello.fu", "-o", "hello"
  end
end
