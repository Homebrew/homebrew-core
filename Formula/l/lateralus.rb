class Lateralus < Formula
  desc "Modern, expressive programming language with type inference and pipelines"
  homepage "https://lateralus.dev"
  url "https://github.com/bad-antics/lateralus-lang/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "NPL-1.0"
  head "https://github.com/bad-antics/lateralus-lang.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0000000000000000000000000000000000000000000000000000000000000000"
    sha256 cellar: :any,                 arm64_sonoma:  "0000000000000000000000000000000000000000000000000000000000000000"
    sha256 cellar: :any,                 sonoma:        "0000000000000000000000000000000000000000000000000000000000000000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0000000000000000000000000000000000000000000000000000000000000000"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "llvm@18"

  def install
    system "cargo", "install", *std_cargo_args

    # Install completions
    generate_completions_from_executable(bin/"lateralus", "completions")

    # Install man pages
    man1.install Dir["doc/man/*.1"]
  end

  test do
    (testpath/"hello.ltl").write <<~LATERALUS
      fn main() {
          println("Hello, Homebrew!")
      }
    LATERALUS

    assert_match "Hello, Homebrew!", shell_output("#{bin}/lateralus run hello.ltl")

    # Test version
    assert_match version.to_s, shell_output("#{bin}/lateralus --version")
  end
end
